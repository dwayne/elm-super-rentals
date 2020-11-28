module Widget.NavBar exposing (view)


import Html exposing (Html, a, div, h1, nav, text)
import Html.Attributes exposing (class, href)
import Route


view : Html msg
view =
  nav [ class "menu" ]
    [ a
      [ href (Route.href Route.Home)
      , class "menu-index"
      ]
      [ h1 [] [ text "SuperRentals" ] ]
    , div [ class "links" ]
        [ a
          [ href (Route.href Route.About)
          , class "menu-about"
          ]
          [ text "About" ]
        , a
          [ href (Route.href Route.Contact)
          , class "menu-contact"
          ]
          [ text "Contact" ]
        ]
    ]
