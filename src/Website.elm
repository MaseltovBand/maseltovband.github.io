module Website exposing (main)

{-| The whole website lives in here. No other pages, just a single one.
-}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import FeatherIcons as Icon
import Html exposing (Html, node)
import Html.Attributes exposing (attribute)


type Media
    = Image String
    | Video String


type alias Model =
    { impressumIsOpen : Bool
    }


{-| The static set of images or videos on the frontpage.
Actually this doesn't even need to be inside the model, as it wont change from user input..
-}
galleryTiles : List Media
galleryTiles =
    [ Image "maseltov-markdorf.jpg"
    , Image "akkordeon.jpg"
    , Video "big-buck-bunny_trailer.webm"
    , Image "kontrabass.jpg"
    ]


{-| The initial State of the website, when a user opens the website.
-}
init : () -> ( Model, Cmd msg )
init _ =
    ( { impressumIsOpen = False }
    , Cmd.none
    )


type Msg
    = SetImpressumOpen Bool


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        SetImpressumOpen open ->
            ( { model | impressumIsOpen = open }, Cmd.none )


mailIcon : Element msg
mailIcon =
    Element.html <|
        Icon.toHtml [] <|
            Icon.withSize 14 <|
                Icon.mail


downIcon : Element msg
downIcon =
    Element.html <|
        Icon.toHtml [] <|
            Icon.withSize 14 <|
                Icon.chevronDown


email : String
email =
    "example@example.com"


viewImpressum : Element msg
viewImpressum =
    column [ spacing 8, alignBottom ]
        [ text "Max Musterman ist verantwortlich"
        , text "70111 Stuttgart"
        , link []
            { url = "mailto:" ++ email
            , label = text ("E-Mail: " ++ email)
            }
        , el [ Font.bold ] (text "Es werden keine Daten gespeichert.")
        ]


{-| view one tile which is either an image or a video, but both from same size
-}
viewMediaTile : Media -> Element msg
viewMediaTile imageOrVideo =
    let
        commonAttributes =
            [ width (px 285)
            , height (px 176)
            , Border.shadow
                { offset = ( 2, 2 )
                , blur = 10
                , size = 4
                , color = rgba 0 0 0 0.1
                }
            ]
    in
    case imageOrVideo of
        Image url ->
            Element.el [ width (fillPortion 1) ] <|
                Element.image commonAttributes
                    { src = url
                    , description = ""
                    }

        Video url ->
            Element.el [ width (fillPortion 1) ] <|
                Element.el commonAttributes
                    (Element.html <|
                        -- Custom html5 element.. https://www.w3schools.com/tags/tag_video.asp
                        node "video"
                            [ attribute "controls" "true"
                            , attribute "id" "video_in_gallery"
                            , attribute "src" url
                            ]
                            [{- node "source"
                                [
                                , attribute "type" "video/webm"
                                ]
                                []
                             -}
                            ]
                    )


view : Model -> Html Msg
view model =
    Element.layout
        [ Font.family
            [ Font.typeface "Ropa"
            , Font.sansSerif
            ]
        , Font.color <| rgb 0.15 0.15 0.15
        , Background.gradient
            { angle = 3.14 - 3.14 * 0.15
            , steps =
                [ rgba255 255 199 0 0.07
                , rgba255 255 43 43 0.07
                ]
            }
        ]
    <|
        column
            [ height fill
            , width fill
            , spacing 120

            -- , explain Debug.todo
            ]
            [ -- Headline
              el
                [ Font.size 64
                , centerX
                , Font.letterSpacing -5
                , paddingEach { top = 100, bottom = 0, left = 0, right = 0 }
                ]
                (text "Maseltov")
            , el
                [ Font.size 36
                , centerX
                , Font.letterSpacing -4
                ]
                (text "Jiddische Lieder aus der alten und neuen Welt.")
            , -- Upcoming Events..
              row
                [ width fill
                , spacing 50
                , Font.letterSpacing -2
                ]
                [ column [ alignTop, width (fillPortion 1) ]
                    [ el [ alignRight ] (text "Nächstes Event:")
                    ]
                , column [ width (fillPortion 1), spacing 3 ]
                    [ el [ alignLeft, Font.strike ] (text "Meersburg")
                    , el [ alignLeft, Font.strike ] (text "30. April 2020")
                    , el [ alignLeft, Font.italic, Font.size 18 ] (text "Coronapause...")
                    ]
                ]
            , -- Gallery
              wrappedRow [ spacing 50, paddingXY 100 0, centerX, width fill, height fill ]
                (List.map viewMediaTile galleryTiles)
            , -- Impressum and Contact.. Impressum may open, Contact only forwards to email.
              row
                [ height fill
                , padding 5
                , spacing 30
                , Font.size 16
                , Font.color <| rgba 0 0 0 0.6
                ]
                [ -- Impressum: Show/Hide button and the content are stacked vertically..
                  column [ alignLeft, alignBottom, height fill, spacing 5 ]
                    [ if model.impressumIsOpen then
                        viewImpressum

                      else
                        Element.none
                    , Input.button
                        [ alignLeft, alignBottom ]
                        { onPress = Just (SetImpressumOpen <| not model.impressumIsOpen)
                        , label =
                            row [ alignLeft, alignBottom, spacing 3 ]
                                [ el []
                                    (if model.impressumIsOpen then
                                        downIcon

                                     else
                                        Element.none
                                    )
                                , el [] (text "Impressum")
                                ]
                        }
                    ]
                , -- Email
                  Input.button [ alignLeft, alignBottom ]
                    { onPress = Just (SetImpressumOpen False)
                    , label =
                        row [ alignLeft, alignBottom, spacing 3 ]
                            [ el [] mailIcon
                            , link []
                                { url = "mailto:" ++ email
                                , label = text "Kontakt"
                                }
                            ]
                    }
                ]
            ]


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
