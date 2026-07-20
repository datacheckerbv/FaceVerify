# Migration guide v8

Upgrading from v7.x to v8.x. There are three breaking changes: two error-code
updates in the `onError` callback, and a format change for the first image in
the `onComplete` output. The other v8 changes are behavior improvements and
internal bug fixes that need no integration work.

The error-code changes affect only handlers that match on the **exact numeric
code**. If you branch on the category **prefix** (the recommended pattern), the
only update you may need is adding a `runtime_error` branch.

## Breaking change: generic runtime errors moved to `runtime_error:8001`

The generic runtime catch-all error (`PROCESSING_ERROR`), reported when an
unexpected error occurs that is not one of the specific categorised failures,
has moved from `capture_error:4001` to its own category `runtime_error:8001`.

As a result:

- `capture_error` is now **camera-only**. It no longer fires for generic
  runtime errors.
- A new `runtime_error` category covers unexpected/generic failures and shows a
  generic overlay message instead of the camera-specific one.
- The code `4001` is **retired** and will not be reused.

Despite the name, `runtime_error` does **not** mean "an error that happened at
runtime" — most categories can fire mid-session. It is the **catch-all of last
resort**, reported only when the SDK cannot attribute a failure to any specific
category. Specific runtime failures keep their specific category (repeated
detection failures are `detect_error`, camera loss is `capture_error`).

> The `8001` slot was previously used by `detect_error:8001`; that code has been
> renumbered to `detect_error:9001` so `runtime_error` can own the `8xxx` range
> and stay aligned with the AutoCapture SDK. See the next section. Always branch
> on the **category prefix**, never the number.

### Before (v7)

```javascript
FV.init({
    ...,
    onError: function(error) {
        // Generic runtime errors arrived as "capture_error:4001"
        if (error.code.startsWith('capture_error')) {
            showCameraRetry();
        }
        console.error(error.code, error.stack);
    }
});
```

### After (v8)

```javascript
FV.init({
    ...,
    onError: function(error) {
        if (error.code.startsWith('capture_error')) {
            // Now strictly a camera failure
            showCameraRetry();
        } else if (error.code.startsWith('runtime_error')) {
            // Generic/unexpected runtime error: show a generic retry UI
            showGenericRetry();
        }
        console.error(error.code, error.stack);
    }
});
```

**Action required** if your `onError` handler either:

- matches the exact string `capture_error:4001` → change it to
  `runtime_error:8001`; or
- routes generic runtime errors through the `capture_error` prefix → those now
  arrive under `runtime_error`. Add a `runtime_error` branch.

Handlers that match `capture_error` purely for camera handling need no change.

## Breaking change: transient detection error moved to `detect_error:9001`

`DETECT_TRANSIENT` — the mid-session "detection failed repeatedly" error — moved
from `detect_error:8001` to `detect_error:9001`. Its category (`detect_error`),
meaning, and behaviour are unchanged; only the number changed, so that
`runtime_error` could take the `8xxx` range and match the AutoCapture SDK.

**Action required** only if your `onError` handler matches the exact string
`detect_error:8001` → change it to `detect_error:9001`. Handlers that match the
`detect_error` prefix need no change.

## Breaking change: the first image is now JPEG

The first image in the `onComplete` output — the identity/comparison image —
is now encoded as **JPEG (quality 90)** instead of PNG. The challenge images
remain PNG. At the same time the identity image is captured at the camera's
native resolution (typically 708×1280 portrait) and gated on stillness and
sharpness, so verification providers receive a face roughly twice as wide as
in v7 — while the JPEG encoding keeps it *smaller* on the wire than v7's PNG.

**Action required:**

- **None** if you forward the unmodified `onComplete` output to the
  DataChecker API. The platform accepts both the v7 and the v8 payload
  formats; sessions are handled per payload, so mixed fleets (some
  integrations on v7, some on v8) work without configuration.
- If you **store, display, or process the images yourself**, do not assume
  every image is PNG. Detect the content type from the data (JPEG base64
  starts with `/9j/`; PNG with `iVBOR`) or from the bytes' magic numbers.
- Do **not** re-encode or otherwise modify image data before sending it to the
  DataChecker API — the payload is validated as received, and modified images
  will be rejected.

## Behavior changes (review, usually no action)

- **Overlay stacking**: the intended `z-index: 1000` on the SDK mount
  container never applied in v7 due to a property-name typo. It now applies.
  If your page deliberately layered chrome above the SDK overlay with a
  z-index below 1000, it will now render underneath — raise it above 1000 if
  that layering was intentional.
- **Stricter capture gating**: the identity capture now waits for a still,
  sharp frame (and a fixed sharpness threshold applies). Users who move a lot
  see a "hold still" prompt and capture can take marginally longer in poor
  lighting; no integration change needed.

## Error code categories

Use the category prefix of `error.code` to determine the type of error. The
numeric suffix is for support diagnostics; include it when reporting issues.
See [Error Codes](../README.md#error-codes) for the category reference.

| Category         | Description                               | Recommended action                                |
| ---------------- | ----------------------------------------- | ------------------------------------------------- |
| `capture_error`  | Camera failure                            | Show camera retry UI or prompt for permission     |
| `detect_error`   | Face detection failed after retries       | Prompt user to try again                          |
| `device_error`   | Device cannot run the face landmarker     | Show "device not supported" — do not offer retry  |
| `init_error`     | Initialization failed                     | Prompt user to refresh the page                   |
| `model_error`    | ML model failed to load                   | Check network connection, retry initialization    |
| `opencv_error`   | Required component failed to load         | Prompt user to refresh or try a different browser |
| `runtime_error`  | Uncategorised failure (catch-all)         | Show generic retry UI                             |
| `settings_error` | Invalid configuration or version mismatch | Verify SDK configuration and hosted assets        |
| `token_error`    | Token missing, invalid, or not permitted  | Verify token credentials                          |

## New language keys

Two keys were added: `runtime_error` (the new generic runtime error message)
and `device_error` (the unsupported-device message — the `device_error`
category has existed since v7.1.0, but it had no message key, so the overlay
showed the raw category name). The built-in language files shipped with the
SDK include both. If you supply your own custom language object, you do not
need to add them (the SDK falls back to the English defaults), but adding them
provides translated messages in the overlay.

```javascript
var LANGUAGE = {
    // ... existing keys ...

    // New in v8
    runtime_error: "Something went wrong. Please try again.",
    device_error: "This device is not supported.",
}
```

## Internal bug fixes (no action required)

These v8 changes require no integration changes; they are documented here for
awareness.

- **Wider camera pixel-format support**: The high-performance (WebCodecs) camera
  path now decodes I420 and NV21 YUV frames in addition to NV12/RGBA. Some
  Android devices (e.g. Samsung Galaxy S24 / S25) deliver I420 frames that were
  previously read as all-black, which could stall the session and surface as
  `capture_error:4003` (frame skip). Any pixel format still not recognised now
  falls back automatically to the slower canvas read path instead of failing.
- **Motion-detection startup race**: If the motion-detection module was used
  before it finished loading, the session could end prematurely with an internal
  error. The SDK now retries the frame while the module loads, and reports a
  genuine load failure through `onError` as `model_error:6001`.
