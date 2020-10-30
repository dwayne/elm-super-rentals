module Main exposing (main)


import Browser
import Browser.Navigation as Nav
import Html exposing (div, h2, p, text)
import Html.Attributes exposing (class)
import Url


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


type alias Model =
  { url : Url.Url
  , key : Nav.Key
  }


init : () -> Url.Url -> Nav.Key -> (Model, Cmd msg)
init _ url key =
  ( Model url key
  , Cmd.none
  )


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


view : Model -> Browser.Document msg
view _ =
  { title = "Super Rentals"
  , body =
    [ div [ class "jumbo" ]
        [ div [ class "right tomster" ] []
        , h2 [] [ text "Welcome to Super Rentals!" ]
        , p [] [ text "We hope you find exactly what you're looking for in a place to stay." ]
        ]
    ]
  }
