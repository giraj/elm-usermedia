module UserMedia (getUserMedia, MediaStream, Options, Error) where

{-|

# Definition
@docs getUserMedia

# Types
@docs MediaStream
@docs Options
@docs Error

-}

import Signal as S
import Task as T
import Native.UserMedia


{-| Should actually be something like:

        audio:Either Bool MediaTrackConstraint, video:Either Boold MediaTrackConstraint

   (http://w3c.github.io/mediacapture-main/getusermedia.html#mediastreamconstraints)
-}
type alias Options
        = { audio:Bool, video:Bool }


{-| todo: implement
   http://w3c.github.io/mediacapture-main/getusermedia.html#idl-def-MediaStream
-}
type alias MediaStream =
    { active:Signal Bool
    , ended:Signal Bool
    , label:String
    , id:String
    }

{-| Error type: currently only possible failure considered is user denying the
access request
-}
type Error = AccessDenied

{-| usage:
    in your model allow for an action that takes an incoming MediaStream,
    then create an effect from this task, and handle the succeeding action
    see elm-usermedia/examples for more.
-}
getUserMedia : Options -> T.Task Error MediaStream
getUserMedia = Native.UserMedia.getUserMedia