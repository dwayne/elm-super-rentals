module Route exposing (Route(..), fromUrl, href)


import Url
import Url.Parser exposing (Parser, (</>), map, oneOf, parse, s, string, top)


type Route
  = Home
  | Rental String
  | About
  | Contact
  | NotFound


parser : Parser (Route -> a) a
parser =
  oneOf
    [ map Home top
    , map Rental (s "rentals" </> string)
    , map About (s "about")
    , map Contact (s "getting-in-touch")
    ]


fromUrl : Url.Url -> Route
fromUrl url =
  Maybe.withDefault NotFound (parse parser url)


href : Route -> String
href route =
  case route of
    Home ->
      "/"

    Rental rentalId ->
      "/rentals/" ++ rentalId

    About ->
      "/about"

    Contact ->
      "/getting-in-touch"

    NotFound ->
      "#"
