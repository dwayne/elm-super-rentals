module Widget.Jumbo exposing (view)


import Html exposing (Html, div)
import Html.Attributes exposing (class)


view : List (Html msg) -> Html msg
view content =
  let
    tomster =
      div [ class "right tomster" ] []
  in
  div [ class "jumbo" ] (tomster :: content)
