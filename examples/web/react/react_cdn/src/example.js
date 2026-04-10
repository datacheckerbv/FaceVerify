import FaceVerify from '@datachecker/faceverify'

const Capture = () => {
    let FV = new FaceVerify();
    FV.init({
        CONTAINER_ID: 'FV_mount',
        LANGUAGE: 'en',
        TOKEN: "<YOUR SDK TOKEN>",
        ASSETS_MODE: "CDN",
        onComplete: function (data) {
            console.log(data)
        },
        onError: function(error) {
            // v7: error is { code, stack }
            console.log(error.code, error.stack)
        },
        onUserExit: function () {
            window.history.back()
        }
    })
}


export default Capture;