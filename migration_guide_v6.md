# Migration Guide: v5.x to v6.0.0

This guide will help you migrate from FaceVerify v5.x to v6.0.0.

## Overview

Version 6.0.0 is a major release that removes deprecated and non-functional configuration options to simplify the SDK API. This release focuses on cleaning up the configuration surface and improving internal architecture without changing core functionality.

## Breaking Changes

### Removed Configuration Options

The following configuration options have been removed from the SDK. If your code uses any of these, you must update it:

#### 1. `BACKEND` (Removed)

**Previously:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    BACKEND: 'wasm',  // ❌ No longer supported
    // ...
});
```

**Now:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    // BACKEND option removed - optimized backend is used automatically
    // ...
});
```

**Why removed:** The backend configuration was not providing meaningful options and was always defaulted to optimized values internally.

---

#### 2. `CAPTURE_WAITING_TIME` (Removed)

**Previously:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    CAPTURE_WAITING_TIME: 500,  // ❌ No longer supported
    // ...
});
```

**Now:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    // Capture timing is now optimized automatically
    // ...
});
```

**Why removed:** The capture timing is now handled internally with improved logic that doesn't require manual configuration.

---

#### 3. `CHALLENGES` (Removed)

**Previously:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    CHALLENGES: ['up', 'right', 'down'],  // ❌ No longer supported
    // ...
});
```

**Now:**

```javascript
// Challenges are now exclusively managed through the SDK token
// Request your token with the desired challenges through the API:
fetch(BASE_ENDPOINT + "/sdk/token?number_of_challenges=2&customer_reference=<CUSTOMER>&validateWatermark=true&services=FACE_VERIFY", {
    method: 'GET',
    headers: HEADERS
})
```

**Why removed:** Challenges should only be specified through the SDK token for security and consistency. The configuration option was redundant and could cause confusion.

---

#### 4. Countdown Configuration (Removed)

The following countdown-related options have been removed:

- `COUNTDOWN`
- `COUNTDOWN_MAX`
- `COUNTDOWN_MIN`

**Previously:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    COUNTDOWN: 1000,      // ❌ No longer supported
    COUNTDOWN_MAX: 2000,  // ❌ No longer supported
    COUNTDOWN_MIN: 500,   // ❌ No longer supported
    // ...
});
```

**Now:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    // Countdown removed - captures happen instantly when conditions are met
    // ...
});
```

**Why removed:** The countdown functionality added unnecessary delay to the capture process. The improved capture logic now works instantly when all quality checks pass, providing a better user experience.

---

#### 5. Challenge Threshold Configuration (Removed)

The following threshold options have been removed:

- `UP_THRESHOLD`
- `DOWN_THRESHOLD`
- `LEFT_THRESHOLD`
- `RIGHT_THRESHOLD`

**Previously:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    UP_THRESHOLD: 35,      // ❌ No longer supported
    DOWN_THRESHOLD: 30,    // ❌ No longer supported
    LEFT_THRESHOLD: 22,    // ❌ No longer supported
    RIGHT_THRESHOLD: 22,   // ❌ No longer supported
    // ...
});
```

**Now:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    // Thresholds are now optimized internally
    // ...
});
```

**Why removed:** These thresholds are now optimized internally based on extensive testing and should not require manual adjustment.

---

#### 6. `MODELS_PATH` (Removed)

**Previously:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    MODELS_PATH: 'models/',  // ❌ No longer supported
    // ...
});
```

**Now:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    ASSETS_FOLDER: 'path/to/assets/',  // ✅ Use this instead
    ASSETS_MODE: 'LOCAL',
    // ...
});
```

**Why removed:** This was redundant with `ASSETS_FOLDER`. All assets (including models) are now managed through the unified assets configuration.

---

#### 7. `MOVEMENT_THRESHOLD` (Removed)

**Previously:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    MOVEMENT_THRESHOLD: 20,  // ❌ No longer supported
    // ...
});
```

**Now:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    // Movement detection is now optimized automatically
    // ...
});
```

**Why removed:** Movement detection is now optimized internally for better liveness detection.

---

#### 8. `STOP_AFTER` (Removed)

**Previously:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    STOP_AFTER: 10000,  // ❌ No longer supported
    // ...
});
```

**Now:**

```javascript
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    // Timeout logic is now handled internally
    // ...
});
```

**Why removed:** The stopping timer functionality was not consistently useful and is now handled more intelligently internally.

## Migration Steps

### Step 1: Review Your Configuration

Check your current FaceVerify initialization code and identify any removed configuration options.

### Step 2: Remove Deprecated Options

Remove all the deprecated configuration options from your initialization code.

**Before (v5.x):**

```javascript
let FV = new FaceVerify();
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    LANGUAGE: 'en',
    BACKEND: 'wasm',
    CAPTURE_WAITING_TIME: 500,
    COUNTDOWN: 1000,
    UP_THRESHOLD: 35,
    DOWN_THRESHOLD: 30,
    LEFT_THRESHOLD: 22,
    RIGHT_THRESHOLD: 22,
    MOVEMENT_THRESHOLD: 20,
    CHALLENGES: ['up', 'right'],
    onComplete: function(data) {
        console.log(data);
    },
    onError: function(error) {
        console.log(error);
    },
    onUserExit: function(error) {
        window.history.back();
    }
});
```

**After (v6.0.0):**

```javascript
let FV = new FaceVerify();
FV.init({
    CONTAINER_ID: 'FV_mount',
    TOKEN: '<SDK_TOKEN>',
    LANGUAGE: 'en',
    // All deprecated options removed
    // Challenges are specified in the SDK token request
    onComplete: function(data) {
        console.log(data);
    },
    onError: function(error) {
        console.log(error);
    },
    onUserExit: function(error) {
        window.history.back();
    }
});
```

### Step 3: Update Asset Configuration (if needed)

If you were using `MODELS_PATH`, switch to the `ASSETS_FOLDER` configuration:

**Before:**

```javascript
FV.init({
    MODELS_PATH: 'models/',
    // ...
});
```

**After:**

```javascript
FV.init({
    ASSETS_FOLDER: 'path/to/assets/',
    ASSETS_MODE: 'LOCAL',
    // ...
});
```

### Step 4: Test Your Application

After removing deprecated options, test your application thoroughly to ensure:

- The SDK initializes correctly
- Face detection and challenges work as expected
- Image capture functions properly
- Callbacks are triggered correctly

---

## Still Valid Configuration Options

The following options are still supported and can be used in v6.0.0:

| **ATTRIBUTE**      | **FORMAT**              | **DEFAULT VALUE** | **NOTES**                                                            |
| ------------------ | ----------------------- | ----------------- | -------------------------------------------------------------------- |
| `ASSETS_FOLDER`    | string                  | `""`              | **optional** - Specifies location of locally hosted assets folder    |
| `ASSETS_MODE`      | string                  | `"CDN"`           | **optional** - Specifies mode: "CDN" or "LOCAL"                      |
| `BACKGROUND_COLOR` | string (Hex color code) | `"#1d3461"`       | **optional** - Specifies the background color using a hex color code |
| `CONTAINER_ID`     | string                  |                   | **required** - div id to mount tool on                               |
| `DEBUG`            | bool                    | `false`           | **optional** - When true, more detailed logs will be visible         |
| `LANGUAGE`         | string                  | `"nl"`            | **required** - Notifications in specific language                    |
| `onComplete`       | javascript function     |                   | **required** - Callback function on complete                         |
| `onError`          | javascript function     |                   | **required** - Callback function on error                            |
| `onUserExit`       | javascript function     |                   | **required** - Callback function on user exit                        |
| `TOKEN`            | string                  |                   | **required** - Datachecker SDK token                                 |

---

## Benefits of v6.0.0

- **Simpler API**: Fewer configuration options mean less cognitive load and easier integration
- **Better Defaults**: Optimized internal parameters provide better performance out of the box
- **Cleaner Codebase**: Removal of unused functionality improves maintainability
- **Improved User Experience**: Instant captures (no countdown delays) provide a smoother flow

---

## Need Help?

For additional support, please contact Datachecker.
