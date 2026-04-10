# Android Integration Guide for FaceVerify Web SDK

This guide walks you through embedding the FaceVerify web SDK in an Android app using WebView. FaceVerify is a JavaScript-based tool — these instructions show how to run it inside a native Android app.

Before proceeding, read the [JavaScript documentation](../../README.md) to understand the SDK configuration options.

## Prerequisites

- Android Studio
- Min SDK 21+ (Android 5.0)
- The FaceVerify `dist/` folder (built or downloaded)

## Step 1: Set Up the Android Project

### 1.1 Add Permissions

In your `AndroidManifest.xml`:

```xml
<uses-feature android:name="android.hardware.camera" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

### 1.2 Add Dependencies

In `build.gradle`:

```groovy
dependencies {
    implementation "androidx.webkit:webkit:1.9.0"
    implementation "androidx.appcompat:appcompat:1.6.1"
}
```

### 1.3 Add SDK Assets

Copy the FaceVerify `dist/` folder into your project's `assets` directory:

```text
app/src/main/assets/FaceVerify/dist/
    index.html
    faceverify.obf.js
    assets/
        ...
```

## Step 2: Set Up Listeners

### 2.1 Output Listener

Receives the face verification result from `onComplete`:

```java
public class OutputListener {
    @JavascriptInterface
    public void postMessage(String message) {
        // message is a JSON string containing captured images
        Log.d("FaceVerify", "Output: " + message);
    }
}
```

### 2.2 Error Listener

Receives errors from `onError` and exit events from `onUserExit`:

```java
public class ErrorListener {
    @JavascriptInterface
    public void postMessage(String message) {
        // v7: message is a JSON string with { code, stack }
        Log.e("FaceVerify", "Error/Exit: " + message);
    }
}
```

## Step 3: Configure the WebView

Inside your Activity's `onCreate()`:

```java
webView = findViewById(R.id.webView);

WebSettings webSettings = webView.getSettings();
webSettings.setJavaScriptEnabled(true);
webSettings.setMediaPlaybackRequiresUserGesture(false);
webSettings.setDomStorageEnabled(true);
webSettings.setAllowFileAccessFromFileURLs(true);

// Configure asset loader to serve local files via https://
final WebViewAssetLoader assetLoader = new WebViewAssetLoader.Builder()
        .addPathHandler("/assets/", new WebViewAssetLoader.AssetsPathHandler(this))
        .build();

webView.setWebViewClient(new WebViewClientCompat() {
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
        return assetLoader.shouldInterceptRequest(request.getUrl());
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        initFaceVerify(view);
    }
});

// Register JS → Native bridges
webView.addJavascriptInterface(new OutputListener(), "outputListenerHandler");
webView.addJavascriptInterface(new ErrorListener(), "errorListenerHandler");

// Grant camera permissions to WebView
webView.setWebChromeClient(new WebChromeClient() {
    @Override
    public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
        Log.d("WebView", consoleMessage.message());
        return true;
    }

    @Override
    public void onPermissionRequest(final PermissionRequest request) {
        request.grant(request.getResources());
    }
});

// Load the SDK
webView.loadUrl("https://appassets.androidplatform.net/assets/FaceVerify/dist/index.html");
```

> **Note:** `WebViewAssetLoader` serves local files via `https://appassets.androidplatform.net`, which allows `fetch()` to work correctly (unlike `file://` URLs). This is essential for FaceVerify as it uses `fetch()` to load its MediaPipe worker script and model files.

## Step 4: Initialize the SDK

```java
private void initFaceVerify(WebView view) {
    // Request camera permission if needed
    if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
            != PackageManager.PERMISSION_GRANTED) {
        ActivityCompat.requestPermissions(this,
            new String[]{Manifest.permission.CAMERA}, CAMERA_REQUEST_CODE);
        return;
    }

    String assetsURL = "https://appassets.androidplatform.net/assets/FaceVerify/dist/assets/";
    String token = "<YOUR SDK TOKEN>";

    String script = "(function() {" +
        "var mount = document.getElementById('FV_mount');" +
        "if (!mount) { mount = document.createElement('div'); mount.id = 'FV_mount'; document.body.appendChild(mount); }" +
        "var fv = new FaceVerify();" +
        "fv.init({" +
        "  CONTAINER_ID: 'FV_mount'," +
        "  LANGUAGE: 'en'," +
        "  TOKEN: '" + token + "'," +
        "  ASSETS_MODE: 'LOCAL'," +
        "  ASSETS_FOLDER: '" + assetsURL + "'," +
        "  onComplete: function(data) {" +
        "    outputListenerHandler.postMessage(JSON.stringify(data));" +
        "  }," +
        "  onError: function(error) {" +
        "    errorListenerHandler.postMessage(JSON.stringify(error));" +
        "  }," +
        "  onUserExit: function() {" +
        "    errorListenerHandler.postMessage(JSON.stringify({type: 'exit'}));" +
        "  }" +
        "});" +
        "})();";

    view.evaluateJavascript(script, null);
}
```

> **v7 breaking change:** `onError` now receives an object `{ code, stack }` instead of a plain string. Use `JSON.stringify(error)` to pass the full error object to native code.

## Step 5: Handle the Result

In your `OutputListener`, parse the JSON to extract face verification data:

```java
@JavascriptInterface
public void postMessage(String message) {
    try {
        JSONObject result = new JSONObject(message);
        JSONArray images = result.getJSONArray("images");

        for (int i = 0; i < images.length(); i++) {
            JSONObject img = images.getJSONObject(i);
            String base64Data = img.getString("data");
            String type = img.getString("type");
            // Process base64-encoded PNG image
        }
    } catch (JSONException e) {
        Log.e("FaceVerify", "Failed to parse output", e);
    }
}
```

## Troubleshooting

- **"Failed to init face landmarker worker"** — `fetch()` is blocked on `file://`. Use `WebViewAssetLoader` to serve via `https://`.
- **Black screen, no camera** — Missing camera permission. Request `CAMERA` permission at runtime.
- **Camera permission denied in JS** — `onPermissionRequest` not implemented. Override `WebChromeClient.onPermissionRequest`.
- **SDK loads but no assets** — Wrong `ASSETS_FOLDER` path. Must match the `WebViewAssetLoader` path exactly.
- **"Worker blob load failed"** — Content-Type for `.js` files is wrong. `WebViewAssetLoader` handles this automatically.
