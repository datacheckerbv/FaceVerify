# iOS Integration Guide for FaceVerify Web SDK

This guide walks you through embedding the FaceVerify web SDK in an iOS app using WKWebView. FaceVerify is a JavaScript-based tool — these instructions show how to run it inside a native Swift app.

Before proceeding, read the [JavaScript documentation](../../README.md) to understand the SDK configuration options.

## Prerequisites

- Xcode 15+
- iOS 15+ deployment target
- The FaceVerify `dist/` folder (built or downloaded)

## Step 1: Add the SDK to Your Project

1. Drag the `dist/` folder (containing `index.html`, `faceverify.obf.js`, and `assets/`) into your Xcode project as a **folder reference** (blue folder icon).

2. Ensure the folder is included in your target's **Copy Bundle Resources** build phase.

## Step 2: Create a Custom URL Scheme Handler

WKWebView blocks `fetch()` requests on `file://` URLs. The FaceVerify SDK uses `fetch()` to load its MediaPipe worker script and model files. To work around this, register a custom URL scheme handler that serves local files with proper HTTP responses.

```swift
import WebKit

final class LocalFileSchemeHandler: NSObject, WKURLSchemeHandler {
    static let customScheme = "localfile"

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url,
              let path = url.path.removingPercentEncoding else {
            urlSchemeTask.didFailWithError(NSError(domain: "LocalFileScheme", code: 404))
            return
        }

        let fileURL = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: fileURL)
            let mimeType = Self.mimeType(for: fileURL)
            let response = HTTPURLResponse(
                url: url, statusCode: 200, httpVersion: "HTTP/1.1",
                headerFields: ["Content-Type": mimeType, "Content-Length": "\(data.count)"]
            )!
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        } catch {
            urlSchemeTask.didFailWithError(error)
        }
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}

    private static func mimeType(for url: URL) -> String {
        switch url.pathExtension.lowercased() {
        case "html":             return "text/html"
        case "js", "mjs":        return "application/javascript"
        case "css":              return "text/css"
        case "wasm":             return "application/wasm"
        case "task", "bin", "data": return "application/octet-stream"
        case "png":              return "image/png"
        case "jpg", "jpeg":      return "image/jpeg"
        case "svg":              return "image/svg+xml"
        case "json":             return "application/json"
        default:                 return "application/octet-stream"
        }
    }
}
```

> **Note:** The `task` and `bin` MIME types are needed for MediaPipe model files used by FaceVerify.

## Step 3: Configure the WebView

```swift
private func setupWebView() {
    let cfg = WKWebViewConfiguration()

    // Register custom scheme so fetch() works with local files
    cfg.setURLSchemeHandler(LocalFileSchemeHandler(), forURLScheme: LocalFileSchemeHandler.customScheme)

    cfg.websiteDataStore = .nonPersistent()
    cfg.allowsInlineMediaPlayback = true
    cfg.mediaTypesRequiringUserActionForPlayback = []
    cfg.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

    let ucc = WKUserContentController()
    ucc.add(self, name: "output")   // Receives SDK callbacks
    cfg.userContentController = ucc

    webView = WKWebView(frame: view.bounds, configuration: cfg)
    webView.navigationDelegate = self
    webView.uiDelegate = self
    view.addSubview(webView)
}
```

## Step 4: Load the SDK

Load `index.html` using the custom scheme instead of `file://`:

```swift
private func loadIndex() {
    guard let indexURL = Bundle.main.url(
        forResource: "index", withExtension: "html",
        subdirectory: "YourDistFolder/dist"
    ) else { return }

    // Convert file:// to localfile:// so the scheme handler serves it
    var components = URLComponents(url: indexURL, resolvingAgainstBaseURL: false)!
    components.scheme = LocalFileSchemeHandler.customScheme

    guard let customURL = components.url else { return }
    webView.load(URLRequest(url: customURL))
}
```

## Step 5: Initialize the SDK

After the page loads, inject the initialization script:

```swift
func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    guard let distURL = webView.url?.deletingLastPathComponent() else { return }
    let assetsURL = distURL.appendingPathComponent("assets").absoluteString

    let script = """
    (function() {
        var mount = document.getElementById('FV_mount');
        if (!mount) {
            mount = document.createElement('div');
            mount.id = 'FV_mount';
            document.body.appendChild(mount);
        }

        var fv = new FaceVerify();
        fv.init({
            CONTAINER_ID: 'FV_mount',
            LANGUAGE: 'en',
            TOKEN: '\(token)',
            ASSETS_MODE: 'LOCAL',
            ASSETS_FOLDER: '\(assetsURL)',
            onComplete: function(data) {
                window.webkit.messageHandlers.output.postMessage({
                    type: 'complete', data: data
                });
            },
            onError: function(error) {
                // v7: error is { code, stack }
                window.webkit.messageHandlers.output.postMessage({
                    type: 'error',
                    code: error.code,
                    stack: error.stack
                });
            },
            onUserExit: function() {
                window.webkit.messageHandlers.output.postMessage({
                    type: 'cancel'
                });
            }
        });
    })();
    """

    webView.evaluateJavaScript(script, completionHandler: nil)
}
```

## Step 6: Handle SDK Callbacks

```swift
func userContentController(
    _ userContentController: WKUserContentController,
    didReceive message: WKScriptMessage
) {
    guard let dict = message.body as? [String: Any],
          let type = dict["type"] as? String else { return }

    switch type {
    case "complete":
        let payload = dict["data"]
        // Process face verification result — see JS docs for output format
        dismiss(animated: true)
    case "error":
        let code = dict["code"] as? String ?? "unknown"
        let stack = dict["stack"] as? String ?? ""
        print("SDK error: \(code)\n\(stack)")
    case "cancel":
        dismiss(animated: true)
    default:
        break
    }
}
```

## Step 7: Grant Camera Permissions (iOS 15+)

FaceVerify requires the front-facing camera. Implement `WKUIDelegate` to auto-grant camera access for local content:

```swift
@available(iOS 15.0, *)
func webView(
    _ webView: WKWebView,
    requestMediaCapturePermissionFor origin: WKSecurityOrigin,
    initiatedByFrame frame: WKFrameInfo,
    type: WKMediaCaptureType,
    decisionHandler: @escaping (WKPermissionDecision) -> Void
) {
    let scheme = frame.request.url?.scheme?.lowercased() ?? ""
    let isLocal = (scheme == "file") || (scheme == LocalFileSchemeHandler.customScheme)
    decisionHandler(isLocal ? .grant : .prompt)
}
```

Also add to `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is needed for face verification.</string>
```

## Troubleshooting

- **"Failed to init face landmarker worker"** — `fetch()` is blocked on `file://`. Use `LocalFileSchemeHandler` (Step 2).
- **White screen, no camera prompt** — Missing `WKUIDelegate`. Implement Step 7.
- **Camera denied silently** — Missing `NSCameraUsageDescription` in Info.plist.
- **SDK loads but no assets** — Wrong `ASSETS_FOLDER` path. Check the URL ends with `/assets/`.
- **"Worker blob load failed"** — MIME type for `.js` files not set. Ensure the scheme handler returns `application/javascript`.
