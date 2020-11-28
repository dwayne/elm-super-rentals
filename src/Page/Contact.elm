module Page.Contact exposing (view)


import Html exposing (Html, a, address, br, h2, p, text)
import Html.Attributes exposing (class, href)
import Route
import Widget.Jumbo


view : List (Html msg)
view =
  [ Widget.Jumbo.view
      [ h2 [] [ text "Contact Us" ]
      , p []
          [ text "Super Rentals Representatives would love to help you"
          , br [] []
          , text "choose a destination or answer any questions you may have."
          ]
      , address []
          [ text "Super Rentals HQ"
          , p []
              [ text "1212 Test Address Avenue"
              , br [] []
              , text "Testington, OR 97233"
              ]
          , a [ href "tel:503.555.1212" ] [ text "+1 (503) 555-1212" ]
          , br [] []
          , a [ href "mailto:superrentalsrep@emberjs.com" ] [ text "superrentalsrep@emberjs.com" ]
          ]
      , a [ href (Route.href Route.About), class "button" ] [ text "About" ]
      ]
  ]
