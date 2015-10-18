import UserMedia exposing (MediaStream, getUserMedia)
import Html exposing (Html, text, div)
import Task
import Effects
import Signal
import StartApp


{-| Model and action definitions. Idea is that the model must keep the acquired
stream from user (here: in a Maybe), and there must exist an action
corresponding to the response from the Effect of getting/requesting user media.
(here: Receive (Maybe MediaStream))
-}


type alias Model = Maybe MediaStream

init : (Model, Effects.Effects Action)
init =
    let request =
            getUserMedia { audio = True, video = False }
                |> Task.toMaybe
                |> Task.map Receive
                |> Effects.task
    in
        (Nothing, request)


type Action
    = Receive Model
    | NoOp


update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
    case action of
        Receive mstream ->
            (mstream, Effects.none)

        NoOp ->
            (model, Effects.none)


view : Signal.Address Action -> Model -> Html
view address model =
    case model of
        Nothing ->
            div [] [ text "Nothing here!" ]

        Just stream ->
            div [] [ text (.label stream) ]


-- StartApp wiring


app =
    StartApp.start
        { init = init
        , update = update
        , view = view
        , inputs = []
        }

main =
    app.html

port tasks : Signal.Signal (Task.Task Effects.Never ())
port tasks =
    app.tasks
