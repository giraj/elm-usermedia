Elm.Native.UserMedia = {};
Elm.Native.UserMedia.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.UserMedia = elm.Native.UserMedia || {};

    if (elm.Native.UserMedia.values) return elm.Native.UserMedia.values;

    var Task = Elm.Native.Task.make(elm);
    var Utils = Elm.Native.Utils.make(elm);

    navigator.getUserMedia = navigator.getUserMedia ||
        navigator.webkitGetUserMedia ||
        navigator.mozGetUserMedia;

    if (!navigator.getUserMedia) {
        console.log("getUserMedia not supported.");

        // how to handle this idiomatically in Elm?
        // insight: getUserMediaWrapper can only be called if
        // getUserMedia is supported
        // => task fails if AccessDenied or something strange
        // (in particular NotSupported isn't a possible error)
        return;
    }

    // Options -> Task Error MediaStream
    function getUserMediaWrapper(options) {
        return Task.asyncFunction(function(callback) {
            navigator.getUserMedia(options, function(stream) {
                callback(Task.succeed(stream))
            // todo: implement a proper return type
            }, function(error) {
                callback(Task.fail(error));
            });
        });
    };

    var values = {
        getUserMedia: getUserMediaWrapper
    };

    return Elm.Native.UserMedia.values = values;
}