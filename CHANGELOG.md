# *CHANGELOG*

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
