module Page.About exposing (view)

import Data.Route as Route
import Html as H
import Html.Attributes as HA
import View.Jumbo
import View.LinkTo


view : List (H.Html msg)
view =
    [ View.Jumbo.view
        [ H.h2 [] [ H.text "About Super Rentals" ]
        , H.p []
            [ [ "The Super Rentals website is a delightful project created to explore Elm."
              , "By building a property rental site,"
              , "we can simultaneously imagine traveling AND building Elm applications."
              ]
                |> String.join " "
                |> H.text
            ]
        , View.LinkTo.view
            { route = Route.Contact
            , text = "Contact Us"
            }
        ]
    ]
