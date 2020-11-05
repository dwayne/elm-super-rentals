module Widget.RentalDetailed exposing (view)


import Data exposing (Rental)
import Html exposing (..)
import Html.Attributes exposing (..)
import Widget.Map
import Widget.RentalImage


view : Bool -> Rental -> (Bool -> msg) -> Html msg
view isLarge rental toMsg =
  article [ class "rental detailed" ]
    [ Widget.RentalImage.view
        isLarge
        [ src rental.image
        , alt ("A picture of " ++ rental.title)
        ]
        toMsg
    , div [ class "details" ]
        [ h3 [] [ text ("About " ++ rental.title) ]
        , div [ class "detail owner" ]
            [ span [] [ text "Owner:" ]
            , text " "
            , text rental.owner
            ]
        , div [ class "detail type" ]
            [ span [] [ text "Type:" ]
            , text " "
            , text (rental.kind ++ " - " ++ rental.category)
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
        , div [ class "detail description" ]
            [ p [] [ text rental.description ]
            ]
        ]
    , Widget.Map.view
        { lat = rental.location.lat
        , lng = rental.location.lng
        , zoom = 12
        , width = 894
        , height = 600
        }
        [ alt ("A map of " ++ rental.title)
        , class "large"
        ]
    ]
