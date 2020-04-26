module Website exposing (main)

{-| The whole website lives in here. No other pages, just a single one.
-}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Html exposing (Html)


type alias Model =
    {}


init : () -> ( Model, Cmd msg )
init _ =
    ( {}, Cmd.none )


update : msg -> Model -> ( Model, Cmd msg )
update _ model =
    ( model, Cmd.none )


view : Model -> Html msg
view _ =
    Element.layout [] <|
        row
            []
            [ el [] (text "hello world") ]


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
