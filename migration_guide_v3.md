# Migration guide v3

The latest v3 update of our software introduces significant changes and enhancements across various platforms and components. This guide provides an overview of these changes to facilitate a smooth migration to the new version.

## Asset Management Refactor

### Overview

We've refactored our codebase, leading to significant changes in how assets are managed:

- **New Asset Location**: All required assets have been consolidated under `dist/assets/`.
- **Integrated Assets**: Additional assets, such as CSS files and images, are now built directly into the FaceVerify code.

### Asset Loading Methods

Assets can be loaded in two ways: via CDN or locally. This choice is configured using `ASSETS_MODE`:

- **CDN Fetching**: To load assets through a CDN, set `ASSETS_MODE: "CDN"`.
- **Local Fetching**: To store and load assets locally, use `ASSETS_MODE: "LOCAL"` along with `ASSETS_FOLDER: "<PATH TO FACEVERIFY FOLDER>/dist/assets/"`.

### Version Control

To ensure compatibility:

- **Separate Asset Versioning**: The assets directory contains a version file, separate from the main file's version.
- **Compatibility Check**: The main file will perform a version check and throw an error if the versions are incompatible.

## Web Integration Changes

### Importing the Codebase

The FaceVerify codebase is now conveniently available on GitHub and NPM. You can retrieve the code using one of the following methods:

#### Cloning from GitHub

To clone the repository, use the following Git command:

```bash
git clone git@github.com:datacheckerbv/FaceVerify.git
```

#### Installing via NPM

To install the package via NPM, use this command:

```bash
npm install --save @datachecker/faceverify
```

For more detailed NPM integration examples, refer to the [NPM examples section](examples/web/npm/npm.md).

### Integration Methods

Once you have the FaceVerify codebase, there are several ways to integrate it into your project:

#### HTML Script Tag

Directly include FaceVerify in your HTML:

```html
<!-- HTML Script Tag Example -->
<script src="../dist/faceverify.obf.js"></script>
```

#### JavaScript Imports

Import FaceVerify into your JavaScript file:

##### ES6 Style Import

```js
// ES6 Style Import
import FaceVerify from '@datachecker/faceverify';
```

##### CommonJS Style Require

```js
// CommonJS Style Require
let FaceVerify = require('@datachecker/faceverify');
```

### Web Configuration Changes

In the latest update, we've made significant changes to how the FaceVerify codebase handles assets:

- **Removal of `ROOT`**: The `ROOT` parameter, previously used to specify the base path of the FaceVerify codebase, has been removed.
- **Centralized Asset Management**: Assets are now managed centrally. This change simplifies the configuration and makes asset management more efficient.

#### Previous Configuration

Previously, the configuration used the `ROOT` parameter to locate assets:

```javascript
// Old Configuration
{
    ROOT: "faceverify/",  // Base path for assets
    // ... other configurations ...
}
```

#### Updated Configuration

In the new configuration, `ASSETS_MODE` and `ASSETS_FOLDER` are used to manage asset locations:

```javascript
// New Configuration
{
    ASSETS_MODE: "LOCAL",                   // Asset mode (e.g., LOCAL or CDN)
    ASSETS_FOLDER: "path/to/hosted/assets/", // Path to the hosted assets
    // ... other configurations ...
}
```

### Removal of Meta tags

Now there is less information required in the `index.html`. 

Previously this was it

```html
<link href="../css/faceverify.css" rel="stylesheet" type="text/css" />
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, minimum-scale=1" />
<meta name="apple-mobile-web-app-capable" content="yes" />
```

Now `css` will already be included in the main file and the meta tags are added automatically. so these tags dont have to be supllied anymore

## iOS Changes

In the new version, we've made significant updates to how assets are managed. The key changes include:

- Replacing `modelURL` with `assetsUrl` for more comprehensive asset management.
- Changing `MODELS_PATH` to `ASSETS_FOLDER` to reflect this shift in focus.
- Introducing `ASSETS_MODE`, which can be set to `"LOCAL"` for local asset management or `"CDN"` to fetch assets from a Content Delivery Network (CDN).

For a more detailed iOS integration example, refer to the [iOS examples section](examples/ios/README.md).

### iOS Prerequisites

Make sure you clone the repo to get the latest files.

```bash
git clone git@github.com:datacheckerbv/FaceVerify.git
```

### iOS Init

**Updated Version**
In the new version, we've changed the way URLs are handled for the HTML file and assets. The `assetsUrl` variable has been introduced to replace `modelUrl`. Here's the updated `viewDidLoad()` method:

```swift
    private var htmlFileURL: URL!
    private var assetsUrl: URL! // New variable

    
    override func viewDidLoad() {
        super.viewDidLoad()
        htmlFileURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "dist")! // Updated path
        assetsUrl = htmlFileURL.deletingLastPathComponent().appendingPathComponent("assets") // New asset handling
        setupWebView()
        webView.loadFileURL(htmlFileURL, allowingReadAccessTo: htmlFileURL.deletingLastPathComponent())
    }
```

**Previous version**
Previously, the `viewDidLoad()` method used `modelUrl` for handling model-related URLs. See the original implementation below:

```swift
    private var htmlFileURL: URL!
    private var modelUrl: URL!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        htmlFileURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "html")!
        modelUrl = htmlFileURL.deletingLastPathComponent().appendingPathComponent("models")
        setupWebView()
        webView.loadFileURL(htmlFileURL, allowingReadAccessTo: htmlFileURL.deletingLastPathComponent())
    }
```

### iOS Config

Here's the updated configuration:

```swift
ASSETS_MODE: "LOCAL", // Mode set to local
ASSETS_FOLDER: "\(assetsUrl)", // Dynamically set to assets URL
```

Or `"CDN"` if you want to fetch the assets from a CDN.

```swift
ASSETS_MODE: "CDN", // Mode set to local
```

Previously, the configuration script was set up differently:

```swift
MODELS_PATH:"\(modelURL)",
```

## Android Changes

In the new version, we've made significant updates to how assets are managed. The key changes include:

- Replacing `modelURL` with `assetsUrl` for more comprehensive asset management.
- Changing `MODELS_PATH` to `ASSETS_FOLDER` to reflect this shift in focus.
- Introducing `ASSETS_MODE`, which can be set to `"LOCAL"` for local asset management or `"CDN"` to fetch assets from a Content Delivery Network (CDN).

For a more detailed Android integration example, refer to the [Android examples section](examples/android/README.md).

### Android Prerequisites

Make sure you clone the repo to get the latest files.

```bash
git clone git@github.com:datacheckerbv/FaceVerify.git
```

### Android Init and Config

Below is the updated configuration script reflecting these changes. Key updates include the use of `assetsUrl` and the new `ASSETS_MODE` and `ASSETS_FOLDER` settings.

```java
String assetsUrl "https://appassets.androidplatform.net/assets/<PATH TO FACEVERIFY FOLDER>/dist/assets/" // referring to assets

String script = "\"\"\n" +
    "let FV = new FaceVerify();\n" +
    "FV.init({\n" +
    "    CONTAINER_ID: 'FV_mount',\n" +
    "    LANGUAGE: 'en',\n" +
    "    ASSETS_MODE: 'LOCAL',\n" + // Mode set to local
    "    ASSETS_FOLDER:\"" + assetsUrl + "\",\n" + // Dynamically set to assets URL
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
```

Previously, the configuration script was set up differently:

```java
String modelUrl "https://appassets.androidplatform.net/assets/<PATH TO FACEVERIFY FOLDER>/html/models/"

String script = "\"\"\n" +
    "let FV = new FaceVerify();\n" +
    "FV.init({\n" +
    "    CONTAINER_ID: 'FV_mount',\n" +
    "    LANGUAGE: 'en',\n" +
    "    MODELS_PATH: \"" + modelUrl + "\",\n" +
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
```
