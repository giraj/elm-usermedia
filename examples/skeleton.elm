import UserMedia exposing (MediaStream, getUserMedia)
import Html exposing (Html, text, div)
import Task as T
import Effects as E
import Signal as S
import StartApp


{-| Model and action definitions. Idea is that the model must keep the acquired
stream from user (here: in a Maybe), and there must exist an action
corresponding to the response from the Effect of getting/requesting user media.
(here: Receive (Maybe MediaStream))
-}


type alias Model = Maybe MediaStream

init : (Model, E.Effects Action)
init =
    let request =
            getUserMedia { audio = True, video = False }
                |> T.toMaybe
                |> T.map Receive
                |> E.task
    in
        (Nothing, request)


type Action
    = Receive Model
    | NoOp


update : Action -> Model -> (Model, E.Effects Action)
update action model =
    case action of
        Receive mstream ->
            (mstream, E.none)

        NoOp ->
            (model, E.none)


view : S.Address Action -> Model -> Html
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

port tasks : Signal (T.Task E.Never ())
port tasks =
    app.tasks