# *CHANGELOG*

## *CHANGES* v6.1.4

- **Infrastructure**: Backend infrastructure updates and improvements to the publishing pipeline.

## *CHANGES* v6.1.3

- **Infrastructure**: Backend infrastructure updates and improvements to the publishing pipeline.

## *CHANGES* v6.1.2

- **Content Security Policy (CSP)**: Added Content Security Policy (CSP) documentation to the README. (see [Content Security Policy (CSP)](README.md#content-security-policy-csp))
- **Moved ML engine to Worker**: The MediaPipe Face Landmarker engine has been moved to a Web Worker to improve performance and responsiveness. This change ensures that the main thread remains unblocked during face detection operations, leading to a smoother user experience.
- **Improved tracking stability**: Enhanced the stability of face tracking, reducing jitter and improving the overall reliability of face detection during movement.

## *CHANGES* v6.1.1

- **Enhanced camera selection**: Improved filtering of available cameras to prioritize front-facing devices and exclude virtual or unsupported cameras, ensuring more reliable capture on multi-camera setups. (see `DESKTOP_MODE` in [Configuration](README.md#configuration))
- **Added device label to output metadata**: The output metadata now includes the label of the active camera device used during capture. This enhancement provides better traceability and context for the captured images, allowing users to identify which camera was utilized in multi-camera setups. The device label can be found in the `device` field of the output metadata. (see [Output](README.md#output))
- **Infrastructure**: Backend infrastructure updates and improvements to the publishing pipeline.

## *CHANGES* v6.1.0

- **Consecutive Same Challenges Allowed**: The SDK now allows consecutive identical challenges in the challenge sequence. This change provides greater flexibility in challenge design and can enhance security by allowing repeated movements.

## *CHANGES* v6.0.1

- **Add Migration Guide**: Added the correct migration guide for migrating to version 6 of this package.

## *CHANGES* v6.0.0

- **Removed Deprecated Configuration Options**: Removed the following configuration options that were either non-functional or no longer needed:
  - `BACKEND`: Neural network execution provider configuration (was defaulted to WASM internally)
  - `CAPTURE_WAITING_TIME`: Waiting time between captures (no longer needed with improved capture logic)
  - `CHALLENGES`: Array of challenges (challenges are now exclusively managed through SDK tokens)
  - `COUNTDOWN`, `COUNTDOWN_MAX`, `COUNTDOWN_MIN`: Countdown timer configuration (removed in favor of instant capture)
  - `DOWN_THRESHOLD`, `UP_THRESHOLD`, `LEFT_THRESHOLD`, `RIGHT_THRESHOLD`: Individual challenge thresholds (now managed internally with optimized defaults)
  - `MODELS_PATH`: Path to models location (replaced by `ASSETS_FOLDER`)
  - `MOVEMENT_THRESHOLD`: Movement detection threshold (now managed internally)
  - `STOP_AFTER`: Stopping timer functionality (no longer needed)
  - `OCCLUSION_MEDIAPIPE`: Occlusion detection mode (now always enabled for MediaPipe)

- **Simplified Configuration**: The SDK configuration is now cleaner and easier to use, focusing only on essential user-facing settings. Internal optimization parameters are now handled automatically.

- **Improved Internal Architecture**:
  - Challenges and transaction IDs are now managed at the core level rather than in settings
  - Countdown/timer functionality has been removed for a more streamlined capture experience
  - Better separation of concerns between public API and internal implementation

- **Documentation Improvements**:
  - Added "Cleanup and Removal" section documenting the `remove()` method for proper SDK cleanup
  - Clarified automatic resource cleanup in callbacks

- **Breaking Changes**: Applications using any of the removed configuration options will need to be updated. See the [Migration Guide v6](migration_guide_v6.md) for detailed upgrade instructions.

## *CHANGES* v5.0.0

- **New FaceDetector Engine**: Face detection now uses the Mediapipe Task Vision package, delivering improved accuracy and performance.  
    This update addresses the Samsung S25 compatibility issue ([issue #5867](https://github.com/google-ai-edge/mediapipe/issues/5867), [issue #5908](https://github.com/google-ai-edge/mediapipe/issues/5908)) reported on the Mediapipe GitHub repository.
- **Default Runtime Changed to CPU**: The default runtime for face detection is now CPU (was GPU). This change improves compatibility with the Samsung S25 and other devices that may not work reliably with GPU.

## *CHANGES* v4.1.0

- **Initial Center Position Check**: Added validation to ensure users are correctly centered before challenge sequence begins.

## *CHANGES* v4.0.2

- **Version number display**: The version number is now visible on the screen, providing users with clear information about the current version of the application.
- **Bugfix**: Fixed an issue that caused checkmark or cross icons to not be displayed.

## *CHANGES* v4.0.0

- **Enhanced Debugging Tools**: Improved tools for easier debugging and troubleshooting.
- **Enhanced Security**: Implemented additional security measures.

## *CHANGES* v3.1.2

- **Optimized `opencv.js` Size**: Reduced the size of `opencv.js`, resulting in faster loading times.
- **Added SIMD Support**: `opencv.js` now supports SIMD (Single Instruction, Multiple Data) for enhanced performance.
- **Updated Compatibility Requirements**: The SDK requires at least ECMAScript 12 (ES12). Please refer to the [Compatibility](README.md#compatibility) section for more details.
- **WebGL Frame Reading**: Implemented WebGL frame reading for improved performance.
- **Efficiency Improvements**: Made minor efficiency fixes, leading to a smoother process.
- **Challenge-Response Sensitivity**: Stabilized challenge-response sensitivity for better reliability.

## *CHANGES* v3.1.1

- Bugfix: Fixed an issue where loading the SDK multiple times could cause errors, ensuring reliable repeated initialization.
- Bugfix: onError callback always caused a blank alert screen.

## *CHANGES* v3.1.0

- Decreased size of `faceverify.obf.js` by 8.38 MiB, resulting in faster loading time.
- Improved UI/UX.
- Changed notifications. (see [Languages](README.md#languages))
- Speed upgrade movement calculation.
- Allow consecutive repetitions of the same challenge.
- Lowered the threshold of the up-challenge.

- Bugfix: No Camera access native iOS now throws the expected error.

## *CHANGES* v3.0.2

- Add V3 migration guide

## *CHANGES* v3.0.1

- Bugfix: Fixed an issue where Next.js compilation would fail when certain arrays were not properly populated.

## *CHANGES* v3.0.0

- Only enable SDK when allowed in token.
- Added demo token functionality.
- Restructured codebase. AutoCapture and FaceVerify can now both be loaded in the same page.
- CSS identifiers renamed.
- Notications can now be loaded as object (json) in config. (See [Languages](README.md#languages).)
- Repositioned Task box.
- Removal of `ROOT`. (see [Configuration](README.md#configuration))
- Introduction `BACKGROUND_COLOR` to change background color. (see [Configuration](README.md#configuration))
- Refactored Codebase.
- Introduction `ASSETS_MODE` and `ASSETS_FOLDER` to fetch assets. (see [Configuration](README.md#configuration))
- NPM install now available
- Script tag import, ES6 style import and CommonJS style import. (see [Importing SDK](README.md#importing-sdk))
- Version control between Assets and Main file. (see [Version control](README.md#version-control))
- Customizable background color. (see [Configuration](README.md#configuration))
- Meta tags are now added automatically.
- Detailed integration examples. (see [Examples](examples/README.md))
- Decreased package size by removing redundant files.

- Bugfix: Short camera glitch on startup.
- Bugfix: Wait until opencv is ready.

## *CHANGES* v2.0.1

- Created [Changelog](#changelog), moved previous logging of changes from [README](README.md) to [Changelog](#changelog).
- Readme addition of [Prerequisites](README.md#prerequisites), [OAuth Token](README.md#oauth-token), [Steps](README.md#steps).
- Moved Readme [SDK Token](README.md#sdk-token).
- Readme extension of [Handling callbacks](README.md#handling-callbacks).
- [Handling callbacks](README.md#handling-callbacks) are now all **required** instead of **optional**.
- Missing **required** settings will throw an error. (see [Configuration](README.md#configuration))
- Now, errors will be thrown when images are missing.
- Added Debug logging. (see [Configuration](README.md#configuration))
- Added missing documentation on change of [output](README.md#output) between `V1` and `V2`.
- Added documentation of [FaceVerify API call](README.md#faceverify-api-call).
- Rewritten documentantion on [Android integration](/android/README.md).

- Bugfix: Task still visibile after completed proces. Task now will be hidden.

## *CHANGES* v2.0.0

- Added Token validation. Application can only be started with a valid token.

## *CHANGES* v1.3.5

- Changed default values of `CAPTURE_WAITING_TIME` & `COUNTDOWN_MAX`. (see [Configuration](README.md#configuration))
- New UI design.
- *REMOVED* `CAPTURE_CHALLENGE_SETS` is not optional anymore. A set of images will be taken at every challenge. (see [Configuration](README.md#configuration))

## *CHANGES* v1.3.4

- Renamed `global.css` to `faceverify.css`
- Root of files can now be configured. (see [Configuration](README.md#configuration))
- Added onUserExit functionality. (see [Configuration](README.md#configuration), [Handling callbacks](README.md#handling-callbacks))
- `Tap to start` on screen is replaced with a button.
- Moved example `index.html` to `html/examples`.
- Refactored README tables.
- Added iOS integration documentation at `ios/`.
- Added ROI meta information in output. This can be used for cropping the face. (see [Output](README.md#output))

## *CHANGES* v1.3.3

- Neural network execution provider is now configurable. (see [Configuration](README.md#configuration))
- Challenge pictures will now be captured as sets to improve post-process liveness detection. After each challenge capture, the user will be prompted to return to the centre where a second picture will be taken.  (see [Configuration](README.md#configuration))
- iOS 15 bug fix.
- Increased oval frame size.
- How far you can turn your face is now a limit.

## *CHANGES* v1.3.2

- Increased challenge thresholds and are now configurable. (see [Configuration](README.md#configuration))
- Corner notifications where missing from default notifications, are now present.

## *CHANGES* v1.3.1

- Improved error handling. All errors can now be shown to the user (`FV.alert(error)`) or logged. (see `index.html`)
- Pose detection now rejects corners unless the correct pose is included.
- Pose detection uses a different method to determine pose.
- Challenges in token will now be verified.
- User will no longer be prompted for nodding on retry.
- Assigned variables will be reinitiliased on retry.
- FaceVerify instance can now be reused or reinited.
- Languages can now be changed on retry. Was not possible due to constant variables.

## *CHANGES* v1.3.0

- Added under exposure check.
- Added blur check.
- Added face occlusion check.
- Added Models (see [Configuration](README.md#configuration), [Models](README.md#models)). ()
- Notifications were loaded using script tags. Now, the language can be chosen in `configuration` (see [Languages](README.md#languages)). The language script will internally be called and loaded.
- Added Token configuration that is required. (see Configuration, Token)
- Added Challenges. (see [Configuration](README.md#configuration), [Challenges](README.md#challenges))
- Added Stopping timer. (see [Configuration](README.md#configuration))
- Added Countdown, can be configured by a fixed value or random within range. (see [Configuration](README.md#configuration))
- Output structure changed. Importantly, image prefix `data:image/jpeg;base64,` wont be included anymore and does not have to be added afterwards. (see [Output](README.md#output))
