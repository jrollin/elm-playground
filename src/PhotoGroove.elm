module PhotoGroove exposing (main)

import Array exposing (Array)
import Browser exposing (element)
import Html exposing (Html, button, div, h1, img, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (..)
import Random


urlPrefix : String
urlPrefix =
    "http://elm-in-action.com/"


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ h1 []
            [ text "Photo Groove" ]
        , button [ onClick ClickedSurpriseMe ] [ text "Random !" ]
        , div [ id "sizeChooser" ] (List.map viewSizeChooser [ Small, Medium, Large ])
        , div [ id "thumbnails", class (sizeToString model.chosenSize) ]
            (List.map (viewThumbnail model.selectedUrl) model.photos)
        , img
            [ class "large"
            , src (urlPrefix ++ "large/" ++ model.selectedUrl)
            ]
            []
        ]


selectPhoto : { description : String, data : String }
selectPhoto =
    { description = "ClickedPhoto", data = "2.jpeg" }


type ThumbnailSize
    = Small
    | Medium
    | Large


viewSizeChooser : ThumbnailSize -> Html Msg
viewSizeChooser size =
    label []
        [ input [ type_ "radio", name "size", onClick (ClickedSize size) ] []
        , text (sizeToString size)
        ]


sizeToString : ThumbnailSize -> String
sizeToString size =
    case size of
        Small ->
            "small"

        Medium ->
            "med"

        Large ->
            "large"


viewThumbnail selectedUrl thumb =
    img
        [ src (urlPrefix ++ thumb.url)
        , classList [ ( "selected", selectedUrl == thumb.url ) ]
        , onClick (ClickedPhoto thumb.url)
        ]
        []


type Msg
    = ClickedPhoto String
    | ClickedSize ThumbnailSize
    | GotSelectedIndex Int
    | ClickedSurpriseMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedPhoto url ->
            ( { model | selectedUrl = url }, Cmd.none )

        ClickedSize size ->
            ( { model | chosenSize = size }, Cmd.none )

        GotSelectedIndex index ->
            ( { model | selectedUrl = getPhotoUrl index }, Cmd.none )

        ClickedSurpriseMe ->
            ( model, Random.generate GotSelectedIndex randomPhotoPicker )


type alias Photo =
    { url : String }


photoArray : Array Photo
photoArray =
    Array.fromList initialModel.photos


randomPhotoPicker : Random.Generator Int
randomPhotoPicker =
    Random.int 0 (Array.length photoArray - 1)


getPhotoUrl : Int -> String
getPhotoUrl index =
    case Array.get index photoArray of
        Just photo ->
            photo.url

        Nothing ->
            ""


type alias Model =
    { photos : List Photo
    , selectedUrl : String
    , chosenSize : ThumbnailSize
    }


initialModel : Model
initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = selectPhoto.data
    , chosenSize = Medium
    }

main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }