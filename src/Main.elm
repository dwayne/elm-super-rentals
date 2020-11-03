module Main exposing (main)


import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

import Route exposing (Route(..))


main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    , onUrlRequest = ClickedLink
    , onUrlChange = ChangedUrl
    }


-- MODEL


type alias Model =
  { url : Url.Url
  , key : Nav.Key
  }


init : () -> Url.Url -> Nav.Key -> (Model, Cmd msg)
init _ url key =
  ( Model url key
  , Cmd.none
  )


-- UPDATE


type Msg
  = ClickedLink Browser.UrlRequest
  | ChangedUrl Url.Url


update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    ClickedLink urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model
          , Nav.pushUrl model.key (Url.toString url)
          )

        Browser.External href ->
          ( model
          , Nav.load href
          )

    ChangedUrl url ->
      ( { model | url = url }
      , Cmd.none
      )


-- VIEW


view : Model -> Browser.Document msg
view model =
  { title = "Super Rentals"
  , body = [ viewApplication model.url ]
  }


viewApplication : Url.Url -> Html msg
viewApplication url =
  div [ class "container" ]
    [ viewNavBar
    , div [ class "body" ]
        [ case Route.fromUrl url of
            Home ->
              viewHome

            About ->
              viewAbout

            Contact ->
              viewContact

            NotFound ->
              viewNotFound
        ]
    ]


viewHome : Html msg
viewHome =
  viewJumbo
    [ h2 [] [ text "Welcome to Super Rentals!" ]
    , p [] [ text "We hope you find exactly what you're looking for in a place to stay." ]
    , a [ href "/about", class "button" ] [ text "About Us" ]
    ]


viewAbout : Html msg
viewAbout =
  viewJumbo
    [ h2 [] [ text "About Super Rentals" ]
    , p [] [ text "The Super Rentals website is a delightful project created to explore Ember. By building a property rental site, we can simultaneously imagine traveling AND building Ember applications." ]
    , a [ href "/getting-in-touch", class "button" ] [ text "Contact Us" ]
    ]


viewContact : Html msg
viewContact =
  viewJumbo
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
    , a [ href "/about", class "button" ] [ text "About" ]
    ]


viewNotFound : Html msg
viewNotFound =
  text "Not found"


viewJumbo : List (Html msg) -> Html msg
viewJumbo content =
  let
    tomster =
      div [ class "right tomster" ] []
  in
    div [ class "jumbo" ] (tomster :: content)


viewNavBar : Html msg
viewNavBar =
  nav [ class "menu" ]
    [ a [ href "/", class "menu-index" ] [ h1 [] [ text "SuperRentals" ] ]
    , div [ class "links" ]
        [ a [ href "/about", class "menu-about" ] [ text "About" ]
        , a [ href "/getting-in-touch", class "menu-contact" ] [ text "Contact" ]
        ]
    ]
