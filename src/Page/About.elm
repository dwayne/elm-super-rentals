module Page.About exposing (view)

import Data.Route as Route
import Html as H
import Html.Attributes as HA
import View.Jumbo


view : List (H.Html msg)
view =
    [ View.Jumbo.view
        [ H.h2 [] [ H.text "About Super Rentals" ]
        , H.p []
            [ H.text "The Super Rentals website is a delightful project created to explore Ember. By building a property rental site, we can simultaneously imagine traveling AND building Ember applications."
            ]
        , H.a
            [ HA.href <| Route.toString Route.Contact
            , HA.class "button"
            ]
            [ H.text "Contact Us" ]
        ]
    ]
