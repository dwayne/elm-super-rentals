module Route exposing (Route(..), fromUrl, href)


import Url
import Url.Parser exposing (Parser, (</>), map, oneOf, parse, s, string, top)


type Route
  = Home
  | Rental String
  | About
  | Contact


fromUrl : Url.Url -> Maybe Route
fromUrl url =
  parse parser url


parser : Parser (Route -> a) a
parser =
  oneOf
    [ map Home top
    , map Rental (s "rentals" </> string)
    , map About (s "about")
    , map Contact (s "getting-in-touch")
    ]


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
