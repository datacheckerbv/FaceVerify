# Android Integration Guide for FaceVerify Web App

Welcome to the Android Integration Guide for FaceVerify Web App. This guide will lead you through the process of seamlessly integrating a JavaScript-based web app into your Android application. By following these steps, you'll be able to harness the full functionality of the FaceVerify tool within your Android app.

Please note that FaceVerify is a web-based tool developed using JavaScript. Before diving into the Android integration process, it's important to acquaint yourself with the JavaScript documentation to gain an understanding of how to configure the tool. The instructions provided here will walk you through the process of executing JavaScript code within a Java environment.

## Prerequisites

Before you begin, ensure you have the following:

- Android Studio installed on your development machine.
- The FaceVerify web app that you intend to integrate into your Android app.

## Step 1: Setting up the Android Project

### 1.1 **Launch Android Studio and Create a New Project**

 Begin by opening Android Studio and either creating a new project or opening an existing one where you wish to integrate the web app.

### 1.2 **Adding Permissions in Manifest**

In your AndroidManifest.xml file, add the necessary permissions for your web app to function properly.

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

### 1.3 **Setting up the Assets Folder**

Create an `assets` folder within your Android app project. To do this, right-click on your app module, navigate to New > Folder > Asset Folder, and create the asset folder. Then, copy the necessary SDK files into this folder.

## Step 2: Preparing the Activity to Run JavaScript SDK

### 2.1 **Requesting Camera Access Permissions**

Prior to utilizing the camera within your web app, ensure you request the necessary permissions from the user.

### 2.2 **Configuring WebView**

Inside the `onCreate()` method of your activity, configure the `WebView` to load and display your web app. This involves enabling JavaScript, setting up the asset loader, and configuring various settings.

```java
WebSettings webSettings = webView.getSettings();
webSettings.setJavaScriptEnabled(true);
webSettings.setMediaPlaybackRequiresUserGesture(false);

// Configure asset loader
final WebViewAssetLoader assetLoader = new WebViewAssetLoader.Builder()
        .addPathHandler("/assets/", new WebViewAssetLoader.AssetsPathHandler(this))
        .addPathHandler("/res/", new WebViewAssetLoader.ResourcesPathHandler(this))
        .build();

// Set WebView client
webView.setWebViewClient(new LocalContentWebViewClient(assetLoader));

// Add JavaScript interface
webView.addJavascriptInterface("<Add your listner class here>");

// Set WebChromeClient for console messages and permissions
webView.setWebChromeClient(new WebChromeClient() {
    @Override
    public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
        '<For printing logs>'
        return true;
    }

    @Override
    public void onPermissionRequest(final PermissionRequest request) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            request.grant(request.getResources());
        }
    }
});

// Load the web app URL
webView.loadUrl("https://appassets.androidplatform.net/assets/index.html");
```

### 2.3 **Creating LocalContentWebViewClient**

Define a private class `LocalContentWebViewClient` extending `WebViewClientCompat` to handle Javascript logging.

```java
private class LocalContentWebViewClient extends WebViewClientCompat {

    private final WebViewAssetLoader mAssetLoader;

    LocalContentWebViewClient(WebViewAssetLoader assetLoader) {
        mAssetLoader = assetLoader;
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
        super.onPageStarted(view, url, favicon);
        String script = "\"\"\n" +
                "            function log(emoji, type, args) {\n" +
                "              window.outPutMessageHandler.postMessage(\n" +
                "                `${emoji} JS ${type}: ${Object.values(args)\n" +
                "                  .map(v => typeof(v) === \"undefined\" ? \"undefined\" : typeof(v) === \"object\" ? JSON.stringify(v) : v.toString())\n" +
                "                  .map(v => v.substring(0, 3000)) // Limit msg to 3000 chars\n" +
                "                  .join(\", \")}`\n" +
                "              )\n" +
                "            }\n" +
                "        \n" +
                "            let originalLog = console.log\n" +
                "            let originalWarn = console.warn\n" +
                "            let originalError = console.error\n" +
                "            let originalDebug = console.debug\n" +
                "        \n" +
                "            console.log = function() { log(\"\uD83D\uDCD7\", \"log\", arguments); originalLog.apply(null, arguments) }\n" +
                "            console.warn = function() { log(\"\uD83D\uDCD9\", \"warning\", arguments); originalWarn.apply(null, arguments) }\n" +
                "            console.error = function() { log(\"\uD83D\uDCD5\", \"error\", arguments); originalError.apply(null, arguments) }\n" +
                "            console.debug = function() { log(\"\uD83D\uDCD8\", \"debug\", arguments); originalDebug.apply(null, arguments) }\n" +
                "        \n" +
                "            window.addEventListener(\"error\", function(e) {\n" +
                "               log(\"\uD83D\uDCA5\", \"Uncaught\", [`${e.message} at ${e.filename}:${e.lineno}:${e.colno}`])\n" +
                "            })\n" +
                "        \"\"";

        view.evaluateJavascript(script, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String s) {
                Log.d("JavaScript onPageStart", s);
            }
        });
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        pageLoadFinished(view);

    }

    @Override
    @RequiresApi(21)
    public WebResourceResponse shouldInterceptRequest(WebView view,
                                                        WebResourceRequest request) {
        return mAssetLoader.shouldInterceptRequest(request.getUrl());
    }



    @Override
    @SuppressWarnings("deprecation") // to support API < 21
    public WebResourceResponse shouldInterceptRequest(WebView view,
                                                        String url) {
        return mAssetLoader.shouldInterceptRequest(Uri.parse(url));
    }
}
```

### 2.4 **JavaScript Interface**

Define a JavaScript interface class to receive messages from JavaScript code.

```java
public class ImageListner {
    @JavascriptInterface
    public void postMessage(String message) {
        //Here you will recive the JSON containing the the images in bytes format.
    }
}
```

### 2.5 **Loading JavaScript SDK**

Configure the FaceVerify SDK and start it. The configuration requires two additional variables: `modelURL`, `TOKEN`.

First, `modelURL` indicates the location where the SDK models can be found. As explained in [2.2](#22-configuring-webview) this will be in the created `assets` folder. The modelURL will than be: `https://appassets.androidplatform.net/assets/models/`

Second, `TOKEN` needs to be replaced by a valid SDK token requested at Datachecker. Please refer to the [Token documentation](https://developer.datachecker.nl/).

As can be seen in the example below, the `postMessage` from [2.4](#24-javascript-interface) is used within the `onComplete` and `onUserExit` callback functions to handle the data.

```java
private void pageLoadFinished(WebView view) {
    if (ContextCompat.checkSelfPermission(DocumentCaptureActivity.this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(new String[]{Manifest.permission.CAMERA}, MY_CAMERA_REQUEST_CODE);
        }
    }else  {
        String modelUrl = "https://appassets.androidplatform.net/assets/models/";

        String script = 
            "let FV = new FaceVerify();\n" +
            "FV.init({\n" +
            "    CONTAINER_ID: 'FV_mount',\n" +
            "    LANGUAGE: 'en',\n" +
            "    MODELS_PATH: \"" + modelURL + "\",\n" +
            "    TOKEN: \"" + TOKEN + "\",\n" +
            "    onComplete: function(data) {\n" +
            "        console.log(data);\n" +
            "        window.webkit.messageHandlers.output.postMessage(data);\n" +
            "        FV.stop();\n" +
            "    },\n" +
            "    onError: function(error) {\n" +
            "        console.log(error);\n" +
            "        FV.stop();\n" +
            "    },\n" +
            "    onUserExit: function(data) {\n" +
            "        window.webkit.messageHandlers.exit.postMessage(data);\n" +
            "    }\n" +
            "});";

        Log.d("JavaScript SCRIPT", script);

        view.evaluateJavascript(script, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String s) {
                Log.d("JavaScriptLog", s);
            }
        });
    }
}
```
