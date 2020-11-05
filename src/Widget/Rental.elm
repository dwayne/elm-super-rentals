module Widget.Rental exposing (view)


import Html exposing (..)
import Html.Attributes exposing (..)
import Rental exposing (Rental)
import Route
import Widget.Map
import Widget.RentalImage


view : Bool -> Rental -> (Bool -> msg) -> Html msg
view isLarge rental toMsg =
  article [ class "rental" ]
    [ Widget.RentalImage.view
        isLarge
        [ src rental.image
        , alt ("A picture of " ++ rental.title)
        ]
        toMsg
    , div [ class "details" ]
        [ h3 []
            [ a [ href (Route.href (Route.Rental rental.id)) ] [ text rental.title ]
            ]
        , div [ class "detail owner" ]
            [ span [] [ text "Owner:" ]
            , text " "
            , text rental.owner
            ]
        , div [ class "detail type" ]
            [ span [] [ text "Type:" ]
            , text " "
            , text rental.kind
            ]
        , div [ class "detail location" ]
            [ span [] [ text "Location:" ]
            , text " "
            , text rental.city
            ]
        , div [ class "detail bedrooms" ]
            [ span [] [ text "Number of bedrooms:" ]
            , text " "
            , text (String.fromInt rental.bedrooms)
            ]
        ]
    , Widget.Map.view
        { lat = rental.location.lat
        , lng = rental.location.lng
        , zoom = 9
        , width = 150
        , height = 150
        }
        [ alt ("A map of " ++ rental.title) ]
    ]
