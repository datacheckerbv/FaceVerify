# Migration guide v7

## Breaking change: `onError` now receives an object

In v7, the `onError` callback receives a structured object `{ code, stack }` instead of a plain string. Any code that reads the error as a string must be updated.

### Before (v6)

```javascript
FV.init({
    ...,
    onError: function(error) {
        // error was a plain string, e.g. "capture_error"
        if (error === 'capture_error') {
            showCameraRetry();
        }
        console.log(error);
    }
});
```

### After (v7)

```javascript
FV.init({
    ...,
    onError: function(error) {
        // error is now { code, stack }
        // code format: "category:NNNN", e.g. "capture_error:4004"
        if (error.code.startsWith('capture_error')) {
            showCameraRetry();
        }
        console.error(error.code, error.stack);
    }
});
```

## Error code categories

Use the category prefix of `error.code` to determine the type of error. The numeric suffix is for support diagnostics — include it when reporting issues.

| Category         | Description                               | Recommended action                                |
| ---------------- | ----------------------------------------- | ------------------------------------------------- |
| `capture_error`  | Camera or processing failure              | Show camera retry UI or prompt for permission     |
| `detect_error`   | Face detection failed after retries       | Prompt user to try again                          |
| `init_error`     | Initialization failed                     | Prompt user to refresh the page                   |
| `model_error`    | ML model failed to load                   | Check network connection, retry initialization    |
| `opencv_error`   | Required component failed to load         | Prompt user to refresh or try a different browser |
| `settings_error` | Invalid configuration or version mismatch | Verify SDK configuration and hosted assets        |
| `token_error`    | Token missing, invalid, or not permitted  | Verify token credentials                          |

## Image output changed from 4 channels to 3 channels

Saved PNG images are now 3-channel BGR instead of 4-channel BGRA. The alpha channel was unused and always fully opaque, so it has been dropped to reduce file size. If your backend decodes the base64 images from `onComplete` and expects 4-channel input, update it to handle 3-channel images.

## New language keys

Six new keys were added for error category messages. Custom language files do not need to include them — the SDK falls back to English defaults — but adding them provides translated messages in the overlay.

```javascript
var LANGUAGE = {
    // ... existing keys ...

    // New in v7
    detect_error:   "Face detection failed. Please try again.",
    init_error:     "Initialization failed. Please refresh the page.",
    model_error:    "Failed to load required resources. Please check your connection.",
    opencv_error:   "A required component failed to load. Please refresh the page.",
    settings_error: "Configuration error. Please contact support.",
    token_error:    "Authorization failed. Please try again later.",
}
```
