# elm-usermedia
elm wrapper for ```navigator.getUserMedia```

## usage
See ```examples/skeleton.elm``` for very basic usage.

Basically, this module exports some types needed to work with user media, and a function
```elm
getUserMedia : Options -> Task Error MediaStream
```
that can be made into an effect that asks for access to microphone, webcam or whatever the ```elm Options``` specify. 
