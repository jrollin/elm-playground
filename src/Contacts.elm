module Contacts exposing (main)

import Browser exposing (element)
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class)
import List exposing (head)
import Set exposing (fromList)


type PrizeCategory
    = Chemistry
    | Literature


type alias Laureate =
    { firstname : String
    , surname : String
    , motivation : String
    , category : PrizeCategory
    , year : String
    }


type Msg
    = ChangedYear


type alias Model =
    { year : String
    , laureates : List Laureate
    }


initialModel : Model
initialModel =
    { year = "2020"
    , laureates =
        [ Laureate
            "Julien"
            "Rollin"
            "Elm is good !"
            Chemistry
            "2010"
        , Laureate
            "John"
            "Doe"
            "Unknown"
            Literature
            "2020"
        , Laureate
            "Jane"
            "Doe"
            "Unknown"
            Literature
            "2020"
        ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


listOfYears : List Laureate -> List String
listOfYears laureates =
    laureates
        |> List.map .year
        |> Set.fromList
        |> Set.toList


viewYears : List Laureate -> Html msg
viewYears laureates =
    div [] (List.map (\x -> div [] [ text x ]) (listOfYears laureates))


viewLaureates : List Laureate -> Html msg
viewLaureates laureates =
    div [ class "laureates" ]
        [ ul []
            (List.map viewLaureate laureates)
        ]


viewLaureate : Laureate -> Html msg
viewLaureate { firstname, surname, motivation } =
    li []
        [ div []
            [ text firstname ]
        , div
            []
            [ text surname ]
        , div
            []
            [ text motivation ]
        ]


view : Model -> Html msg
view model =
    div []
        [ viewYears model.laureates
        , viewLaureates model.laureates
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
