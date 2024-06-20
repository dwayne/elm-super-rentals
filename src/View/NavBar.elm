module View.NavBar exposing (view)

import Data.Route as Route
import Html as H
import Html.Attributes as HA


view : H.Html msg
view =
    H.nav [ HA.class "menu" ]
        [ H.a
            [ HA.href <| Route.toString Route.Home
            , HA.class "menu-index"
            ]
            [ H.h1 [] [ H.text "SuperRentals" ] ]
        , H.div [ HA.class "links" ]
            [ H.a
                [ HA.href <| Route.toString Route.About
                , HA.class "menu-about"
                ]
                [ H.text "About" ]
            , H.a
                [ HA.href <| Route.toString Route.Contact
                , HA.class "menu-contact"
                ]
                [ H.text "Contact" ]
            ]
        ]
