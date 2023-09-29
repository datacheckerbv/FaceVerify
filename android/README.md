# Android Integration Guide for FaceVerify Web App

Welcome to the Android Integration Guide for FaceVerify Web App. This guide will lead you through the process of seamlessly integrating a JavaScript-based web app into your Android application. By following these steps, you'll be able to harness the full functionality of the FaceVerify tool within your Android app.

Please note that FaceVerify is a web-based tool developed using JavaScript. Before diving into the Android integration process, it's important to acquaint yourself with the JavaScript documentation to gain an understanding of how to configure the tool. The instructions provided here will walk you through the process of executing JavaScript code within a Java environment.

## Prerequisites

Before you begin, ensure you have the following:

- Android Studio installed on your development machine.
- The FaceVerify repository.

## Step 1: Setting up the Android Project

### 1.1 **Launch Android Studio and Create a New Project**

Begin by opening Android Studio and either creating a new project or opening an existing one where you wish to integrate the web app.

### 1.2 **Adding Permissions in Manifest**

In your `AndroidManifest.xml` file, add the necessary permissions.

- Camera: To take capture documents.
- Internet: WebView requirement.

Example `xml`:

```xml
<uses-feature android:name="android.hardware.camera" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET"/>
```

### 1.3 **Set dependencies**

In `build.gradle` add the following dependencies to your project.

Example `groovy`:

```groovy
dependencies {
    // other dependencies
    implementation "androidx.webkit:webkit:1.2.0"
    implementation 'androidx.appcompat:appcompat:1.4.1'
    implementation 'com.google.android.material:material:1.5.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.3'
}
```

### 1.4 **Setting up the Assets Folder**

Create an `assets` folder within your Android app project. To do this, right-click on your app module, navigate to New > Folder > Asset Folder, and create the asset folder. Then, copy the FaceVerify SDK files into this folder.

Example:

`assets/FaceVerify`

## Step 2: Preparing the Activity to Run FaceVerify SDK

### 2.1 **Set up listeners**

#### 2.1.1 **Output listener**

Define a JavaScript interface class to receive output messages from the FaceVerify SDK. This listener will be called `onComplete` and is defined within the FaceVerify configuration.

```java
public class OutputListener {
    @JavascriptInterface
    public void postMessage(String message) {
        //Here you will receive the JSON containing the the images in bytes format.
    }
}
```

#### 2.1.2 **Exit listener**

Define a JavaScript interface class to receive output messages from the FaceVerify SDK. This listener will be called `onUserExit` and is defined within the FaceVerify configuration.

```java
public class ExitListener {
    @JavascriptInterface
    public void postMessage(String message) {
        //Here you will receive the JSON containing the the images in bytes format.
    }
}
```

### 2.2 **Loading FaceVerify SDK**

Before continuing, please make sure to read the [Configuration](../README.md#configuration) documentation.

Now, we will configure the FaceVerify SDK and start it. An example is given below. In this example, the configuration requires two additional variables: `modelURL`, `TOKEN`.

First, `modelURL` indicates the location where the SDK models can be found. As explained in [1.4](#14-setting-up-the-assets-folder) this will be in the created `assets` folder. The `modelURL` will than be: `https://appassets.androidplatform.net/assets/<PATH TO FaceVerify FOLDER>/html/models/`

Second, `TOKEN` needs to be replaced by a valid [SDK Token](../README.md#sdk-token).

As can be seen in the example below, the `listeners` from [2.1](#21-set-up-listeners) are used within the `onComplete`, `onError` and `onUserExit` callback functions to handle the data.

```java
private void startFaceVerifyConfig(WebView view) {
    // Requesting Camera Access Permissions
    if (ContextCompat.checkSelfPermission(DocumentCaptureActivity.this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(new String[]{Manifest.permission.CAMERA}, MY_CAMERA_REQUEST_CODE);
        }
    }else  {
        String modelUrl = "https://appassets.androidplatform.net/assets/<PATH TO FaceVerify FOLDER>/html/models/";

        String script = "\"\"\n" +
            "let FV = new FaceVerify();\n" +
            "FV.init({\n" +
            "    CONTAINER_ID: 'FV_mount',\n" +
            "    LANGUAGE: 'en',\n" +
            "    MODELS_PATH: \"" + modelURL + "\",\n" +
            "    TOKEN: \"" + TOKEN + "\",\n" +
            "    onComplete: function (data) {\n" +
            "        outputListenerHandler.postMessage(JSON.stringify(data));\n" +
            "    },\n" +
            "    onError: function(error) {\n" +
            "        exitListenerHandler.postMessage(error);\n" +
            "     },\n" +
            "     onUserExit: function (data) {\n" +
            "        exitListenerHandler.postMessage(data);\n" +
            "     }\n" +
            "});\n" +
            "\"\"";

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

### 2.4 **Creating FaceVerifyWebViewClient**

Define a private class `FaceVerifyWebViewClient` extending `WebViewClientCompat`.

```java
private class FaceVerifyWebViewClient extends WebViewClientCompat {

    private final WebViewAssetLoader mAssetLoader;

    FaceVerifyWebViewClient(WebViewAssetLoader assetLoader) {
        mAssetLoader = assetLoader;
    }

    // Start FaceVerify after WebView is loaded. 
    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        startFaceVerifyConfig(view);
    }

    // Load assets URL
    @Override
    @RequiresApi(21)
    public WebResourceResponse shouldInterceptRequest(WebView view,
                                                        WebResourceRequest request) {
        return mAssetLoader.shouldInterceptRequest(request.getUrl());
    }


    // Load assets URL
    @Override
    @SuppressWarnings("deprecation") // to support API < 21
    public WebResourceResponse shouldInterceptRequest(WebView view,
                                                        String url) {
        return mAssetLoader.shouldInterceptRequest(Uri.parse(url));
    }
}
```

### 2.5 **Configuring WebView**

Inside the `onCreate()` method of your activity, configure the `WebView` to load and display your web app. This involves enabling JavaScript, setting up the asset loader, and configuring various settings.

```java
// Create WebView
webView = findViewById(<YOUR ID>);

WebSettings webSettings = webView.getSettings();
webSettings.setJavaScriptEnabled(true);
webSettings.setMediaPlaybackRequiresUserGesture(false);

// Configure asset loader
final WebViewAssetLoader assetLoader = new WebViewAssetLoader.Builder()
        .addPathHandler("/assets/", new WebViewAssetLoader.AssetsPathHandler(this))
        .addPathHandler("/res/", new WebViewAssetLoader.ResourcesPathHandler(this))
        .build();

// Set FaceVerifyWebViewClient client
webView.setWebViewClient(new FaceVerifyWebViewClient(assetLoader));

// Add Output listener
webView.addJavascriptInterface(new OutputListener(), "outputListenerHandler");

// Add Exit listener
webView.addJavascriptInterface(new ExitListener(), "exitListenerHandler");

// Set WebChromeClient for console messages and permissions
webView.setWebChromeClient(new WebChromeClient() {
    @Override
    public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
        Log.d(consoleMessage.message())
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
webView.loadUrl("https://appassets.androidplatform.net/assets/<PATH TO FaceVerify FOLDER>/index.html");
```
