
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

### Required
| **name**       | **type**            | **default value** | **example**                            | **description**                                                     |
|----------------|---------------------|-------------------|----------------------------------------|---------------------------------------------------------------------|
| `CONTAINER_ID` | string              |                   | `"FV_mount"`                           | *div id*  to mount tool on.                                         |
| `TOKEN`        | string              |                   | `"eyJpZCI6IjdkY..."`                   | *base64 token* string containing *challenges* and *transaction id*. |
| `LANGUAGE` | string              |  `"nl"`                 | `"nl"`                           | Notifications in specific language. 
| `onComplete`   | javascript function |                   | `function(data) {console.log(data)}`   | callback function on  *complete* .                                  |
| `onError`      | javascript function |                   | `function(error) {console.log(error)}` | callback function on *error*.                                       |

### Optional
| **name**               | **type** | **default value** | **example**                             | **description**                                                                                                  |
|------------------------|----------|-------------------|-----------------------------------------|------------------------------------------------------------------------------------------------------------------|
| `MODELS_PATH`   | string      | `"models/"`              | `"models/"`                          | Path referring to models location.                                                                               |
| `MOVEMENT_THRESHOLD`   | int      | `20`              | `20`                                    | Movement will be calculated from frame to frame with a value between 0-100. Recommended value between 20 and 30. |
| `CAPTURE_WAITING_TIME` | int      | `500`             | `500`                                   | Waiting time between capturing in milliseconds.                                                                  |
| `CHALLENGES`           | array    |                   | `['up', 'right', 'down', 'left', 'up']` | Array of  `challenges`  that can be used for Demo purposes.                                                      |
| `STOP_AFTER`           | int      |                   | `10000`                                 | Stopping timer in ms.                                                                                            |
| `COUNTDOWN`            | int      |                   | `3000`                                  | Countdown in ms before picture is taken.                                                                         |
| `COUNTDOWN_MIN`        | int      | `500`             | `500`                                   | If `COUNTDOWN == 0` then countdown will be a random between `COUNTDOWN_MIN` and `COUNTDOWN_MAX`.                 |
| `COUNTDOWN_MAX`        | int      | `1500`            | `1500`                                  | If `COUNTDOWN == 0` then countdown will be a random between `COUNTDOWN_MIN` and `COUNTDOWN_MAX`.                 |

## Usage/Examples

The tool first needs to be initialised to load all the models. 
Once its initialised, it can be started with the function `FV.start();`

```javascript
let FV = new FaceVerify();
FV.init({
    CONTAINER_ID: ...,
    LANGUAGE: ...,
    onComplete: ...,
    onError: ...
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
    }
}).then(() => {
    // Tap to start
    document.addEventListener('touchstart', FV.start)
    window.onclick = FV.start
});
```


## Requirements

CSS stylesheet.
```html
<link href="css/global.css" rel="stylesheet" type="text/css" />
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
<link href="css/global.css" rel="stylesheet" type="text/css" />
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
        }
    }).then(() => {
        // Tap to start
        document.addEventListener('touchstart', FV.start)
        window.onclick = FV.start
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
const LANGUAGE = {
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
    "challenge_1": "Slowly move your face up.",
    "challenge_2": "Slowly move your face to the right.",
    "challenge_3": "Slowly move your face down.",
    "challenge_4": "Slowly move your face to the left."
}
```

## Models
The tool uses a collection of neural networks. Make sure that you host the full directory so the models can be accessed. The models path can be configured. (see [Configuration](#configuration))
The models are located under `models/`. Model cards can also be found in this directory.

## Token
In order to use the SDK in production a *token* is required. This token is a `base64` string containing *challenges* and *transaction id*. The token can be generated by calling the [Datachecker Token API](https://developer.datachecker.nl) . 

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
    "token": "base64_token",
    "valid_challenges": "true|false"
}
```

Example:
```json
{   
    "livePhotos": ["/9j/4AAQSkZJRgABAQAAAQABAAD/...", "/9j/4AAQSkZJRgABAQAAAQABAAD/...", "/9j/4AAQSkZJRgABAQAAAQABAAD/..."],
    "token": "eyJpZCI6IjdkYWMxN2IzLWQ2YTktNDhiYi04MzhhLWEzZjA5YTMyY2EwYiIsImNoYWxsZW5nZXMiOlsidXAiLCJyaWdodCJdfQ==",
    "valid_challenges": true
}
```


## *CHANGES*
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