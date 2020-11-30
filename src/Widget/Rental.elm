module Widget.Rental exposing (view)


import Data exposing (Rental)
import Html exposing (Html, a, article, div, h3, span, text)
import Html.Attributes exposing (alt, class, href, src)
import Route
import Widget.Map
import Widget.RentalImage


view : msg -> msg -> Bool -> Rental -> Html msg
view onEnlargeClick onShrinkClick isLarge rental =
  article [ class "rental" ]
    [ Widget.RentalImage.view
        onEnlargeClick
        onShrinkClick
        isLarge
        [ src rental.image
        , alt ("A picture of " ++ rental.title)
        ]
    , div [ class "details" ]
        [ h3 []
            [ a
              [ href (Route.href (Route.Rental rental.id)) ]
              [ text rental.title ]
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
