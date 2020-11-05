module Main exposing (main)


import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page exposing (Page)
import Route exposing (Route)
import Url
import Widget.NavBar


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
  { key : Nav.Key
  , page : Page
  }


init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key =
  Page.fromRoute (Route.fromUrl url)
    |> Tuple.mapBoth (Model key) (Cmd.map GotPage)


-- UPDATE


type Msg
  = ClickedLink Browser.UrlRequest
  | ChangedUrl Url.Url
  | GotPage Page.Msg


update : Msg -> Model -> (Model, Cmd Msg)
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
      Page.fromRoute (Route.fromUrl url)
        |> Tuple.mapBoth (Model model.key) (Cmd.map GotPage)

    GotPage pageMsg ->
      ( { model | page = Page.update pageMsg model.page }
      , Cmd.none
      )


-- VIEW


view : Model -> Browser.Document Msg
view { page } =
  { title = "Super Rentals"
  , body =
      Page.view page
        |> List.map (Html.map GotPage)
  }
