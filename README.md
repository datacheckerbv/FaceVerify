
# FaceVerify

This project contains Datachecker's FaceVerify tool, that captures images of faces to be used in liveness detection. The tool only takes a capture once the trigger mechanism is fired.

To perform liveness detection, two slightly different images of the same person are required. For example, when a person moves his/her head slightly this will generate a different image. Therefore, the tool checks difference in movement between frames.

The tool features user challenge-response, namely head pose estimation, in order to prevent video injection attacks.

The tool will be run in the browser and is therefore written in JavaScript.

## Trigger mechanism

The tool performs the following checks:

- Is the environment not too dark (under exposure)?
- Is there a face?
- Is the face occluded?
- Is the detected face not too far?
- Is the detected face not too close?
- Is the face centered?
- Is the image sharp?
- Is there movement?

The movement check will only be used for the second picture. Since the first picture has no other picture to compare to.

## Configuration

To run this tool, you will need initialise with the following variables.

| **ATTRIBUTE**            | **FORMAT**          | **DEFAULT VALUE**                      | **EXAMPLE**                                                                                              | **NOTES**                                                                                                                                              |
| ------------------------ | ------------------- | -------------------------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `BACKEND`                | string              | `wasm`                                 | `wasm`                                                                                                   | **optional**<br> Neural network execution provider. Possible values: [`wasm`, `webgl`, `cpu`]. `wasm` is recommended whereas `cpu` is not recommended. |
| `CAPTURE_WAITING_TIME`   | int                 | `0`                                  | `500`                                                                                                    | **optional**<br> Waiting time between capturing in milliseconds.                                                                                       |
| `CHALLENGES`             | array               |                                        | `['up', 'right', 'down', 'left', 'up']`                                                                  | **optional**<br> Array of `challenges` that can be used for Demo purposes.                                                                             |
| `CONTAINER_ID`           | string              |                                        | `"FV_mount"`                                                                                             | **required**<br> *div id* to mount tool on.                                                                                                            |
| `COUNTDOWN_MAX`          | int                 | `0`                                  | `500`                                                                                                    | **optional**<br> If `COUNTDOWN == 0` then countdown will be a random between `COUNTDOWN_MIN` and `COUNTDOWN_MAX`.                                      |
| `COUNTDOWN_MIN`          | int                 | `0`                                    | `0`                                                                                                      | **optional**<br> If `COUNTDOWN == 0` then countdown will be a random between `COUNTDOWN_MIN` and `COUNTDOWN_MAX`.                                      |
| `COUNTDOWN`              | int                 | `0`                                    | `3000`                                                                                                   | **optional**<br> Countdown in ms before picture is taken.                                                                                              |
| `DOWN_THRESHOLD`         | int                 | `30`                                   | `30`                                                                                                     | **optional**<br> Challenge `down` threshold value.                                                                                                     |
| `LANGUAGE`               | string              | `"nl"`                                 | `"nl"`                                                                                                   | **required**<br> Notifications in specific language.                                                                                                   |
| `LEFT_THRESHOLD`         | int                 | `22`                                   | `22`                                                                                                     | **optional**<br> Challenge `left` threshold value.                                                                                                     |
| `MODELS_PATH`            | string              | `"models/"`                            | `"models/"`                                                                                              | **optional**<br> Path referring to models location.                                                                                                    |
| `MOVEMENT_THRESHOLD`     | int                 | `20`                                   | `20`                                                                                                     | **optional**<br> Movement will be calculated from frame to frame with a value between 0-100. Recommended value between 20 and 30.                      |
| `RIGHT_THRESHOLD`        | int                 | `22`                                   | `22`                                                                                                     | **optional**<br> Challenge `right` threshold value.                                                                                                    |
| `ROOT`                   | string              | `""`                                   | `"../"`                                                                                                  | **optional**<br> Root location.                                                                                                                        |
| `STOP_AFTER`             | int                 |                                        | `10000`                                                                                                  | **optional**<br> Stopping timer in ms.                                                                                                                 |
| `TOKEN`                  | string              |                                        | `"eyJpZCI6IjdkYWMxN2IzLWQ2YTktNDhiYi04MzhhLWEzZjA5YTMyY2EwYiIsImNoYWxsZW5nZXMiOlsidXAiLCJyaWdodCJdfQ=="` | **required**<br> *base64 token* string containing *challenges* and *transaction id*.                                                                   |
| `UP_THRESHOLD`           | int                 | `35`                                   | `35`                                                                                                     | **optional**<br> Challenge `up` threshold value.                                                                                                       |
| `onComplete`             | javascript function |                                        | `function(data) {console.log(data)}`                                                                     | **required**<br> Callback function on *complete* .                                                                                                     |
| `onError`                | javascript function | `function(error) {console.log(error)}` | `function(error) {console.log(error)}`                                                                   | **optional**<br> Callback function on *error*.                                                                                                         |
| `onUserExit`             | javascript function | `function(error) {console.log(error)}` | `function(error) {window.history.back()}`                                                                | **optional**<br> Callback function on *user exit*.                                                                                                     |

## Handling callbacks

```javascript
let FV = new FaceVerify();
FV.init({
    CONTAINER_ID: 'FV_mount',
    LANGUAGE: 'en',
    onComplete: function(data) {
        console.log(data);
        FV.stop();
    },
    onError: function(error) {
        console.log(error)
        FV.stop();
        FV.alert(error)
    },
    onUserExit: function(error) {
        console.log(error);
        FV.stop();
    }
});
```

| **ATTRIBUTE**            | **FORMAT**          | **DEFAULT VALUE**                      | **EXAMPLE**                                                                                              | **NOTES**                                                                                                                                              |
| ------------------------ | ------------------- | -------------------------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `onComplete`             | javascript function |                                        | `function(data) {console.log(data)}`                                                                     | **required**<br> Callback that fires when all interactive tasks in the workflow have been completed.                                                                                                     |
| `onError`                | javascript function | `function(error) {console.log(error)}` | `function(error) {console.log(error)}`                                                                   | **optional**<br> Callback that fires when an *error* occurs.                                                                                                         |
| `onUserExit`             | javascript function | `function(error) {console.log(error)}` | `function(error) {window.history.back()}`                                                                | **optional**<br> Callback that fires when the user exits the flow without completing it.                                                                                                     |

## Usage/Examples

The tool first needs to be initialised to load all the models.
Once its initialised, it can be started with the function `FV.start();`

```javascript
let FV = new FaceVerify();
FV.init({
    CONTAINER_ID: ...,
    LANGUAGE: ...,
    onComplete: ...,
    onError: ...,
    onUserExit: ...,
}).then(() => {
    FV.start();
});
```

To stop the camera and delete the container with its contents the stop function can be called.

```javascript
...
FV.stop();
```

Example below:

```javascript
let FV = new FaceVerify();
FV.init({
    CONTAINER_ID: 'FV_mount',
    LANGUAGE: 'nl',
    onComplete: function(data) {
        console.log(data);
        FV.stop();
    },
    onError: function(error) {
        console.log(error)
        FV.stop();
        FV.alert(error)
    },
    onUserExit: function(error) {
        console.log(error);
        FV.stop();
    },
});
```

## Requirements

CSS stylesheet.

```html
<link href="css/faceverify.css" rel="stylesheet" type="text/css" />
```

The meta tags below are required to view the tool properly.

```html
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, minimum-scale=1" />
<meta name="apple-mobile-web-app-capable" content="yes" />
```

Load script.

```js
<script src="js/faceverify.obf.js" type="text/javascript"></script>
```

## Demo

File present under `html/index.html`

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>FaceVerify</title>
<link href="css/faceverify.css" rel="stylesheet" type="text/css" />
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, minimum-scale=1" />
<meta name="apple-mobile-web-app-capable" content="yes" />
</head>

<body>
    <div id="FV_mount" style="height:100vh">
    </div>
</body>

<script src="js/faceverify.obf.js" type="text/javascript"></script>
<script>
    let FV = new FaceVerify();
    FV.init({
        CONTAINER_ID: 'FV_mount',
        LANGUAGE: 'en',
        TOKEN:"eyJpZCI6IjdkYWMxN2IzLWQ2YTktNDhiYi04MzhhLWEzZjA5YTMyY2EwYiIsImNoYWxsZW5nZXMiOlsidXAiLCJyaWdodCJdfQ==",
        onComplete: function(data) {
            console.log(data)
            FV.stop();
        },
        onError: function(error) {
            console.log(error)
            FV.stop();
            FV.alert(error)
        },
        onUserExit: function(error) {
            console.log(error);
            FV.stop();
        },
    });    
</script>

</html>
```

## Languages

The languages can be found in `js/language/`. The current support languages are `en` and `nl`. More languages could be created.

The notifications can be loaded in `configuration` like the following:

```javascript
let FV = new FaceVerify();
FV.init({
    LANGUAGE: 'en',
    ...
```

To create support for a new language, a js file needs to be created with specific keys.
The keys can be derived from the current language js files (`js/language/en.js`).

Example:

```javascript
var LANGUAGE = {
    "start_prompt": "Tap to start.",
    "no_face": "No face detected,\nplease position your face in the frame.",
    "nod_head": "Please nod your head slightly.",
    "face_thresh": "Face not clearly visible.\nEnsure better lighting conditions\nor make sure your face is not covered.",
    "face_far": "Please move closer to the camera.",
    "face_close": "Face too close,\nplease move slightly away.",
    "exp_dark": "The image is too dark.\nFind a well-lit environment.",
    "exp_light": "The image is too light.\nFind a dimmer environment.",
    "blur": "Image is not sharp,\nplease stay still.",
    "capture_error": "We could not capture an image.\nAccess to the camera is required.",
    "challenge_0": "Slowly move your face to the center.",
    "challenge_out": "Watch out, your face is too far in the specified direction.\nMove slightly back.",
    "challenge_1": "Slowly move your face up\nand hold still.",
    "challenge_12": "Watch out, you are looking diagonally upwards.\nSlowly move your face upwards and hold still.",
    "challenge_14": "Watch out, you are looking diagonally upwards.\nSlowly move your face upwards and hold still.",
    "challenge_2": "Slowly move your face to the right\nand hold still.",
    "challenge_21": "Watch out, you are looking diagonally upwards.\nSlowly move your face to the right and hold still.",
    "challenge_23": "Watch out, you are looking diagonally downwards.\nSlowly move your face to the right and hold still.",
    "challenge_3": "Slowly move your face down\nand hold still.",
    "challenge_32": "Watch out, you are looking diagonally downwards.\nSlowly move your face downwards and hold still.",
    "challenge_34": "Watch out, you are looking diagonally downwards.\nSlowly move your face downwards and hold still.",
    "challenge_4": "Slowly move your face to the left\nand hold still.",
    "challenge_41": "Watch out, you are looking diagonally upwards.\nSlowly move your face to the left and hold still.",
    "challenge_43": "Watch out, you are looking diagonally downwards.\nSlowly move your face to the left and hold still."
}
```

## Models

The tool uses a collection of neural networks. Make sure that you host the full directory so the models can be accessed. The models path can be configured. (see [Configuration](#configuration))
The models are located under `models/`. Model cards can also be found in this directory.

## Token

In order to use the SDK in production a *token* is required. This token is a `base64` string containing *challenges* and *transaction id*. The token can be generated by calling the [Datachecker Token API](https://developer.datachecker.nl).

## Challenges

User challenges are implemented, in order to prevent video injection attacks. These challenges are randomly chosen and thereby, processes are different from one another. The challenges consist of *head pose estimation*. The performed head poses with be compared with the challenges and that result will be returned as bool in `output`. (see [Output](#output))

There are four poses that will be detected:

- up
- right
- down
- left

For Demo purposes challenges can be loaded using the `CHALLENGES` configuration. This will be an array with the challenges in order. 

```javascript
let FV = new FaceVerify();
FV.init({
    CONTAINER_ID: 'FV_mount',
    LANGUAGE: 'nl',
    CHALLENGES: ['up', 'right', 'down', 'left', 'up'],
    ...
```

In production, challenges *will not* be loaded using the `CHALLENGES` configuration! Instead, challenges are embedded in the `TOKEN`. Therefore, the challenges are not directly visible. 

```javascript
let FV = new FaceVerify();
FV.init({
    CONTAINER_ID: 'FV_mount',
    LANGUAGE: 'nl',
    TOKEN: "eyJpZCI6IjdkYWMxN2IzLWQ2YTktNDhiYi04MzhhLWEzZjA5YTMyY2EwYiIsImNoYWxsZW5nZXMiOlsidXAiLCJyaWdodCJdfQ==",
    ...
```

## Output

The SDK will output in the following structure:

```json
{   
    "livePhotos": ["base64_img1", "..."],
    "meta": [{"x":"", "y":"", "width":"", "height":""}, "..."],
    "token": "base64_token",
    "valid_challenges": "true|false"
}
```

Example:

```json
{   
    "livePhotos": ["/9j/4AAQSkZJRgABAQAAAQABAAD/...", "/9j/4AAQSkZJRgABAQAAAQABAAD/...", "/9j/4AAQSkZJRgABAQAAAQABAAD/..."],
    "meta": [{"x": 33, "y": 182, "width": 265, "height": 354}, {"x": 33, "y": 182, "width": 265, "height": 354}, {"x": 33, "y": 182, "width": 265, "height": 354}],
    "token": "eyJpZCI6IjdkYWMxN2IzLWQ2YTktNDhiYi04MzhhLWEzZjA5YTMyY2EwYiIsImNoYWxsZW5nZXMiOlsidXAiLCJyaWdodCJdfQ==",
    "valid_challenges": true
}
```

## *CHANGES* v1.3.0

- Added under exposure check.
- Added blur check.
- Added face occlusion check.
- Added Models (see [Configuration](#configuration), [Models](#models)).
- Notifications were loaded using script tags. Now, the language can be chosen in `configuration` (see [Languages](#languages)). The language script will internally be called and loaded.
- Added Token configuration that is required. (see Configuration, Token)
- Added Challenges. (see [Configuration](#configuration), [Challenges](#challenges))
- Added Stopping timer. (see [Configuration](#configuration))
- Added Countdown, can be configured by a fixed value or random within range. (see [Configuration](#configuration))
- Output structure changed. Importantly, image prefix `data:image/jpeg;base64,` wont be included anymore and does not have to be added afterwards. (see [Output](#output))

## *CHANGES* v1.3.1

- Improved error handling. All errors can now be shown to the user (`FV.alert(error)`) or logged. (see `index.html`)
- Pose detection now rejects corners unless the correct pose is included.
- Pose detection uses a different method to determine pose.
- Challenges in token will now be verified.
- User will no longer be prompted for nodding on retry.
- Assigned variables will be reinitiliased on retry.
- FaceVerify instance can now be reused or reinited.
- Languages can now be changed on retry. Was not possible due to constant variables.

## *CHANGES* v1.3.2

- Increased challenge thresholds and are now configurable. (see [Configuration](#configuration))
- Corner notifications where missing from default notifications, are now present.

## *CHANGES* v1.3.3

- Neural network execution provider is now configurable. (see [Configuration](#configuration))
- Challenge pictures will now be captured as sets to improve post-process liveness detection. After each challenge capture, the user will be prompted to return to the centre where a second picture will be taken.  (see [Configuration](#configuration))
- iOS 15 bug fix.
- Increased oval frame size.
- How far you can turn your face is now a limit.

## *CHANGES* v1.3.4

- Renamed `global.css` to `faceverify.css`
- Root of files can now be configured. (see [Configuration](#configuration))
- Added onUserExit functionality. (see [Configuration](#configuration), [Handling callbacks](#handling-callbacks))
- `Tap to start` on screen is replaced with a button.
- Moved example `index.html` to `html/examples`.
- Refactored README tables.
- Added iOS integration documentation at `ios/`.
- Added ROI meta information in output. This can be used for cropping the face. (see [Output](#output))

## *CHANGES* v1.3.5

- Changed default values of `CAPTURE_WAITING_TIME` & `COUNTDOWN_MAX`. (see [Configuration](#configuration))
- New UI design.
- *REMOVED* `CAPTURE_CHALLENGE_SETS` is not optional anymore. A set of images will be taken at every challenge. (see [Configuration](#configuration))