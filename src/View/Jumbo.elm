module View.Jumbo exposing (view)

import Html as H
import Html.Attributes as HA


view : List (H.Html msg) -> H.Html msg
view content =
    let
        tomster =
            H.div [ HA.class "right tomster" ] []
    in
    H.div [ HA.class "jumbo" ] (tomster :: content)
