module Page.Contact exposing (view)

import Data.Route as Route
import Html as H
import Html.Attributes as HA
import View.Jumbo
import View.LinkTo


view : List (H.Html msg)
view =
    [ View.Jumbo.view
        [ H.h2 [] [ H.text "Contact Us" ]
        , H.p []
            [ H.text "Super Rentals Representatives would love to help you"
            , H.br [] []
            , H.text "choose a destination or answer any questions you may have."
            ]
        , H.address []
            [ H.text "Super Rentals HQ"
            , H.p []
                [ H.text "1212 Test Address Avenue"
                , H.br [] []
                , H.text "Testington, OR 97233"
                ]
            , H.a [ HA.href "tel:503.555.1212" ] [ H.text "+1 (503) 555-1212" ]
            , H.br [] []
            , H.a [ HA.href "mailto:superrentalsrep@emberjs.com" ] [ H.text "superrentalsrep@emberjs.com" ]
            ]
        , View.LinkTo.view
            { route = Route.About
            , text = "About"
            }
        ]
    ]
