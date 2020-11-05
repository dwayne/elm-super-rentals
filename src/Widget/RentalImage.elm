module Widget.RentalImage exposing (view)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


view :  Bool -> List (Attribute msg) -> (Bool -> msg) -> Html msg
view isLarge attrs toMsg =
  if isLarge then
    button [ class "image large", onClick (toMsg False) ]
      [ img attrs
          []
      , small [] [ text "View Smaller" ]
      ]
  else
    button [ class "image", onClick (toMsg True) ]
      [ img attrs
          []
      , small [] [ text "View Larger" ]
      ]
