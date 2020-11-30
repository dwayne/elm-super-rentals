module Widget.RentalImage exposing (view)


import Html exposing (Attribute, Html, button, img, small, text)
import Html.Attributes exposing (class)
import Html.Events as E


view : msg -> msg -> Bool -> List (Attribute msg) -> Html msg
view onEnlargeClick onShrinkClick isLarge attrs =
  if isLarge then
    button
      [ class "image large"
      , E.onClick onShrinkClick
      ]
      [ img attrs []
      , small [] [ text "View Smaller" ]
      ]
  else
    button
      [ class "image"
      , E.onClick onEnlargeClick
      ]
      [ img attrs []
      , small [] [ text "View Larger" ]
      ]
