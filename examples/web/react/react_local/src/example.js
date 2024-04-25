import FaceVerify from '@datachecker/faceverify'

const Capture = () => {
    let FV = new FaceVerify();
    FV.init({
        CONTAINER_ID: 'FV_mount',
        LANGUAGE: 'en',
        TOKEN: "<YOUR SDK TOKEN>",
        ASSETS_MODE: "LOCAL",
        ASSETS_FOLDER: "http://localhost:5000/assets",
        onComplete: function (data) {
            console.log(data)
        },
        onError: function(error) {
            console.log(error)
        },
        onUserExit: function () {
            window.history.back()
        }
    })
}


export default Capture;