module Layout exposing (jumbo)


import Html exposing (..)
import Html.Attributes exposing (..)


jumbo : List (Html msg) -> Html msg
jumbo content =
  let
    tomster =
      div [ class "right tomster" ] []
  in
    div [ class "jumbo" ] (tomster :: content)
