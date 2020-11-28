module Widget.RentalImage exposing (view)


import Html exposing (Attribute, Html, button, img, small, text)
import Html.Attributes exposing (class)
import Html.Events as E


view : (Bool -> msg) -> Bool -> List (Attribute msg) -> Html msg
view handleClick isLarge attrs =
  if isLarge then
    button
      [ class "image large"
      , E.onClick (handleClick False)
      ]
      [ img attrs []
      , small [] [ text "View Smaller" ]
      ]
  else
    button
      [ class "image"
      , E.onClick (handleClick True)
      ]
      [ img attrs []
      , small [] [ text "View Larger" ]
      ]
