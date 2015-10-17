module UserMedia (getUserMedia, MediaStream, Options, Error) where

{-| This library wraps navigator.getUserMedia into a Task in Elm that succeeds
with a MediaStream object and fails with AccessDenied. Hand the task to a port
or make an Effect out of it in order to request access to the user's media.

# Definition
@docs getUserMedia

# Types
@docs MediaStream
@docs Options
@docs Error

-}

import Signal exposing (Signal)
import Task
import Native.UserMedia


{-| The Options type allows you to specify the media you want to request. 
For further information, see:
   http://w3c.github.io/mediacapture-main/getusermedia.html#mediastreamconstraints
(todo: implement more of specification)
-}
type alias Options
        = { audio:Bool, video:Bool }

{-| MediaStream is the type of the MediaStream object returned by 
navigator.getUserMedia, for further information see complete specification:
   http://w3c.github.io/mediacapture-main/getusermedia.html#idl-def-MediaStream
(todo: implement more of specification)
-}
type alias MediaStream
    = { active:Signal Bool -- todo: don't think this automatically works?
      , ended:Signal Bool
      , label:String
      , id:String
      }

{-| This is the error type of getUserMedia. Currently the only 'failure' 
considered is when the user denies access.
-}
type Error = AccessDenied

{-| Prompt user for access to microphone and/or camera as specified by Options. 
Can be handed to a port or made into an Effect, see examples/ for more details.
Usage (with ports and mailboxes):

    media : Signal.Mailbox (Maybe MediaStream)
    media = Signal.mailbox Nothing

    port requestMedia : Maybe MediaStream
    port requestMedia =
        let options = { audio = True, video = False }
        in
            Task.toMaybe getUserMedia options
                Task.andThen` Signal.send media.address
-}
getUserMedia : Options -> Task.Task Error MediaStream
getUserMedia = Native.UserMedia.getUserMedia
