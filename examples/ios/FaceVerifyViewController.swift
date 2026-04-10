//
//  FaceVerifyViewController.swift
//  Example integration of the FaceVerify Web SDK in iOS using WKWebView.
//
//  Prerequisites:
//  - Add LocalFileSchemeHandler.swift to your project (see README.md)
//  - Add FaceVerify dist/ folder as a folder reference in Xcode
//  - Add NSCameraUsageDescription to Info.plist
//

import UIKit
import WebKit

class FaceVerifyViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    private var webView: WKWebView!
    var token: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupWebView()
        loadIndex()
    }

    // MARK: - WebView Setup

    private func setupWebView() {
        let cfg = WKWebViewConfiguration()

        // Register custom scheme so fetch() works with local files
        cfg.setURLSchemeHandler(LocalFileSchemeHandler(), forURLScheme: LocalFileSchemeHandler.customScheme)

        cfg.websiteDataStore = .nonPersistent()
        cfg.allowsInlineMediaPlayback = true
        cfg.mediaTypesRequiringUserActionForPlayback = []
        cfg.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        let ucc = WKUserContentController()

        // Console bridge: forwards JS console.log/warn/error to Xcode console
        let consoleBridge = """
        (function(){
          function safe(arg){
            try{ return typeof arg==='string'?arg:JSON.stringify(arg); }catch(e){ return String(arg); }
          }
          function post(t,m){ try{ window.webkit.messageHandlers.logging.postMessage({type:t,msg:m}); }catch(e){} }
          var L=console;
          ['log','warn','error'].forEach(function(k){
            var orig=L[k];
            console[k]=function(){ var msg=Array.prototype.map.call(arguments,safe).join(' '); post(k,msg); if(orig)orig.apply(L,arguments); };
          });
          window.addEventListener('error',function(e){ post('error',(e.message||'')+' '+(e.error&&e.error.stack||'')); });
          window.addEventListener('unhandledrejection',function(e){ var r=e.reason; post('error','Promise rejection: '+(r&&r.message||safe(r))); });
        })();
        """
        ucc.addUserScript(WKUserScript(source: consoleBridge, injectionTime: .atDocumentStart, forMainFrameOnly: true))

        ucc.add(self, name: "output")
        ucc.add(self, name: "logging")
        cfg.userContentController = ucc

        webView = WKWebView(frame: .zero, configuration: cfg)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Load SDK

    private func loadIndex() {
        guard let indexURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "dist") else {
            print("❌ FaceVerify index.html not found in dist/")
            return
        }

        // Convert file:// to localfile:// so the scheme handler serves it
        var components = URLComponents(url: indexURL, resolvingAgainstBaseURL: false)!
        components.scheme = LocalFileSchemeHandler.customScheme

        guard let customURL = components.url else { return }
        webView.load(URLRequest(url: customURL))
    }

    // MARK: - Initialize SDK after page load

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let distURL = webView.url?.deletingLastPathComponent() else { return }
        let assetsURL = distURL.appendingPathComponent("assets").absoluteString

        let script = """
        (function() {
            var mount = document.getElementById('FV_mount');
            if (!mount) { mount = document.createElement('div'); mount.id = 'FV_mount'; document.body.appendChild(mount); }

            function post(type, payload) {
                try { window.webkit.messageHandlers.output.postMessage(Object.assign({type:type}, payload||{})); } catch(e){}
            }

            var fv = new FaceVerify();
            fv.init({
                CONTAINER_ID: 'FV_mount',
                LANGUAGE: 'en',
                TOKEN: '\(token)',
                ASSETS_MODE: 'LOCAL',
                ASSETS_FOLDER: '\(assetsURL)',
                onComplete: function(data) {
                    post('complete', { data: data });
                },
                onError: function(error) {
                    // v7: error is { code, stack }
                    post('error', { code: error.code, stack: error.stack });
                },
                onUserExit: function() {
                    post('cancel');
                }
            });
        })();
        """

        webView.evaluateJavaScript(script, completionHandler: nil)
    }

    // MARK: - Handle SDK callbacks

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logging" {
            if let o = message.body as? [String: Any], let t = o["type"] as? String, let m = o["msg"] as? String {
                print("FV \(t): \(m)")
            }
            return
        }

        guard let dict = message.body as? [String: Any],
              let type = dict["type"] as? String else { return }

        switch type {
        case "complete":
            let payload = dict["data"]
            print("✅ FaceVerify complete: \(String(describing: payload))")
            dismiss(animated: true)
        case "error":
            let code = dict["code"] as? String ?? "unknown"
            let stack = dict["stack"] as? String ?? ""
            print("❌ FaceVerify error: \(code)\n\(stack)")
        case "cancel":
            print("ℹ️ FaceVerify user exit")
            dismiss(animated: true)
        default:
            break
        }
    }

    // MARK: - Camera permissions (iOS 15+)

    @available(iOS 15.0, *)
    func webView(_ webView: WKWebView,
                 requestMediaCapturePermissionFor origin: WKSecurityOrigin,
                 initiatedByFrame frame: WKFrameInfo,
                 type: WKMediaCaptureType,
                 decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        let scheme = frame.request.url?.scheme?.lowercased() ?? ""
        let isLocal = (scheme == "file") || (scheme == LocalFileSchemeHandler.customScheme)
        decisionHandler(isLocal ? .grant : .prompt)
    }
}
