module Main exposing (main)


import Html exposing (div, h2, p, text)
import Html.Attributes exposing (class)


main =
    div [ class "jumbo" ]
        [ div [ class "right tomster" ] []
        , h2 [] [ text "Welcome to Super Rentals!" ]
        , p [] [ text "We hope you find exactly what you're looking for in a place to stay." ]
        ]
