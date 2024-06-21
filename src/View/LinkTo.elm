module View.LinkTo exposing (ViewOptions, view)

import Data.Route as Route exposing (Route)
import Html as H
import Html.Attributes as HA


type alias ViewOptions =
    { route : Route
    , text : String
    }


view : ViewOptions -> H.Html msg
view { route, text } =
    H.a
        [ HA.href <| Route.toString route
        , HA.class "button"
        ]
        [ H.text text ]
