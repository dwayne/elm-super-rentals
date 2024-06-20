module Data.Route exposing (Route(..), fromUrl, toString)

import Url exposing (Url)
import Url.Builder as UB
import Url.Parser as UP exposing ((</>))


type Route
    = Home
    | Rental String
    | About
    | Contact


fromUrl : Url -> Maybe Route
fromUrl =
    UP.parse routeParser


routeParser : UP.Parser (Route -> a) a
routeParser =
    UP.oneOf
        [ UP.map Home UP.top
        , UP.map Rental (UP.s "rentals" </> UP.string)
        , UP.map About (UP.s "about")
        , UP.map Contact (UP.s "getting-in-touch")
        ]


toString : Route -> String
toString route =
    let
        path =
            case route of
                Home ->
                    []

                Rental rentalId ->
                    [ "rentals", rentalId ]

                About ->
                    [ "about" ]

                Contact ->
                    [ "getting-in-touch" ]
    in
    UB.absolute path []
