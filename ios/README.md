# iOS Integration Guide for FaceVerify Web App

This guide will walk you through the process of integrating a JavaScript web app into an iOS app using the `FaceVerifyViewController` as an example. By following these steps, you will be able to embed your web app within an iOS app and leverage its functionality seamlessly.

Please note that FaceVerify is a web-based tool written in JavaScript. Before proceeding with the iOS integration, make sure to familiarize yourself with the JavaScript documentation to understand how to configure the tool. The following instructions will guide you through running the JavaScript code within a Swift environment.

## Prerequisites

Before getting started, make sure you have the following:

- Xcode installed on your development machine.
- The FaceVerify web app that you want to integrate into your iOS app.

## Step 1: Set up the iOS Project

1. Launch Xcode and create a new iOS project or open an existing project where you want to integrate the web app.

2. Add the necessary JavaScript files and other web app resources to your Xcode project. Make sure to maintain the directory structure of your web app.

3. Create a new Swift file (or use an existing one) and name it `FaceVerifyViewController.swift`. Copy the provided code for the `FaceVerifyViewController` into this file.

4. Import the required frameworks at the top of the `FaceVerifyViewController.swift` file, including `UIKit`, `WebKit`, and `Foundation`.

5. Make sure you have the required dependencies imported. Check if the following dependencies are added to your project's dependencies:

   - UIKit
   - WebKit

6. Replace any references to `self.token` in the code with your appropriate token value or the property that holds the token response. Make sure to set the `TOKEN` parameter in the JavaScript code inside the `webView(_:didFinish:)` method with the corresponding token value from your model or data structure.

## Step 2: Set the HTML File URL

1. Open the `FaceVerifyViewController.swift` file.

2. Locate the `htmlFileURL` property declaration inside the `FaceVerifyViewController` class.

3. Set the `htmlFileURL` to the location of the imported FaceVerify web app repo within your Xcode project. You can use the `Bundle.main.url` method to get the appropriate URL. For example:

   ```swift
   htmlFileURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "path/to/web/app")!
   ```

   Replace `"path/to/web/app"` with the actual path to the imported FaceVerify web app repo within your Xcode project.

## Step 3: Storyboard Setup (Optional)

If you prefer to use a storyboard for designing your UI, you can follow these steps:

1. Open the Main.storyboard file (or create a new one).

2. Drag and drop a `WKWebView` onto your view controller's scene.

3. Connect the `webView` outlet in the `FaceVerifyViewController` to the `WKWebView` you added in the storyboard.

4. Set up the desired constraints for the `WKWebView` to define its position and size on the screen.

## Step 4: Configuring the WebView

1. Inside the `viewDidLoad()` method of the `FaceVerifyViewController`, configure the `WKWebView` by creating a `WKWebViewConfiguration` object.

2. Customize the `WKWebViewConfiguration` object as needed. For example, you need to enable inline media playback by setting `allowsInlineMediaPlayback` to `true`.

3. Configure the `WKUserContentController` by adding message handlers and user scripts. This allows communication between the web app and the iOS app.

4. Set the `navigationDelegate` of the `webView` to the current view controller.

## Step 5: Loading the Web App

1. Call the `loadFileURL(_:allowingReadAccessTo:)` method on the `webView` instance to load the web app's HTML file. Pass the appropriate file URL and allow read access to the necessary directories.

2. Implement the delegate method `webView(_:didFinish:)` from the `WKNavigationDelegate` protocol. This method will be called when the web view finishes loading the web app.

3. Inside the `webView(_:didFinish:)` method, evaluate any necessary JavaScript code using `evaluateJavaScript(_:completionHandler:)`. This allows you to interact with the web app from your iOS code.

```swift
extension FaceVerifyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let script = """
            let FV = new FaceVerify();
            FV.init({
                CONTAINER_ID: 'FV_mount',
                LANGUAGE: 'en',
                MODELS_PATH:"\(self.modelUrl)",
                TOKEN:"\(self.token)",
                onComplete: function(data) {
                    console.log(data);
                    window.webkit.messageHandlers.output.postMessage(data);
                    FV.stop();
                },
                onError: function(error) {
                    console.log(error);
                    FV.stop();
                },
                onUserExit: function(error) {
                    console.log(error);
                    FV.stop();
                }
            });
        """
        
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
```

## Step 6: Handling Communication with the Web App

1. Implement the delegate method `userContentController(_:didReceive:)` from the `WKScriptMessageHandler` protocol. This method is responsible for handling messages sent from the web app.

2. Extract the message body as a dictionary and process the data as needed. You can pass data between the web app and the iOS app using this message handler.

3. Customize the logic inside `userContentController(_:didReceive:)` based on your specific requirements.

```swift
extension FaceVerifyViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String: AnyObject] else {
            return
        }
        print(dict)
        dismiss(animated: true, completion: nil)
    }
}
```
