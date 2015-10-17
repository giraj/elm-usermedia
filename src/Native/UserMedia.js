Elm.Native.UserMedia = {};
Elm.Native.UserMedia.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.UserMedia = elm.Native.UserMedia || {};

    if (elm.Native.UserMedia.values) return elm.Native.UserMedia.values;

    var Task = Elm.Native.Task.make(elm);

    navigator.getUserMedia = navigator.getUserMedia ||
        navigator.webkitGetUserMedia ||
        navigator.mozGetUserMedia;

    if (!navigator.getUserMedia) {
        // how to handle this idiomatically in Elm?
        // insight: getUserMediaWrapper can only be called if
        // getUserMedia is supported
        // => task fails if AccessDenied or something strange
        // (in particular NotSupported isn't a possible error)
        console.log("getUserMedia not supported.");
        return;
    }

    // Options -> Task Error MediaStream
    function getUserMediaWrapper(options) {
        return Task.asyncFunction(function(callback) {
            navigator.getUserMedia(options, function(stream) {
                callback(Task.succeed(stream))
            }, function(error) {
                // todo: should handle different error types
                callback(Task.fail({ 
                    ctor: 'AccessDenied'
                }));
            });
        });
    };

    var values = {
        getUserMedia: getUserMediaWrapper
    };

    return Elm.Native.UserMedia.values = values;
}