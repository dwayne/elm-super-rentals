module View.Rental exposing (ViewOptions, view)

import Data.Rental exposing (Rental)
import Data.Route as Route
import Html as H
import Html.Attributes as HA
import View.Map
import View.RentalImage


type alias ViewOptions msg =
    { rental : Rental
    , isLarge : Bool
    , onToggleSize : Bool -> msg
    }


view : ViewOptions msg -> H.Html msg
view { rental, isLarge, onToggleSize } =
    H.article [ HA.class "rental" ]
        [ View.RentalImage.view
            { title = rental.title
            , image = rental.image
            , isLarge = isLarge
            , onToggleSize = onToggleSize
            }
        , H.div [ HA.class "details" ]
            [ H.h3 []
                [ H.a
                    [ HA.href <| Route.toString <| Route.Rental rental.id ]
                    [ H.text rental.title ]
                ]
            , H.div [ HA.class "detail owner" ]
                [ H.span [] [ H.text "Owner:" ]
                , H.text " "
                , H.text rental.owner
                ]
            , H.div [ HA.class "detail type" ]
                [ H.span [] [ H.text "Type:" ]
                , H.text " "
                , H.text rental.kind
                ]
            , H.div [ HA.class "detail location" ]
                [ H.span [] [ H.text "Location:" ]
                , H.text " "
                , H.text rental.city
                ]
            , H.div [ HA.class "detail bedrooms" ]
                [ H.span [] [ H.text "Number of bedrooms:" ]
                , H.text " "
                , H.text <| String.fromInt rental.bedrooms
                ]
            ]
        , View.Map.view
            { lat = rental.location.lat
            , lng = rental.location.lng
            , zoom = 9
            , width = 150
            , height = 150
            , attrs =
                [ HA.alt <| "A map of " ++ rental.title
                ]
            }
        ]
