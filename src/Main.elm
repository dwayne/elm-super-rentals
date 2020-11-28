module Main exposing (main)


import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.About
import Page.Contact
import Page.Home
import Page.Rental
import Route exposing (Route)
import Url exposing (Url)
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
  { url : Url
  , key : Nav.Key
  , page : Page
  }


type Page
  = Home Page.Home.Model
  | Rental Page.Rental.Model
  | About
  | Contact
  | NotFound


init : () -> Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key =
  fromUrl url
    |> Tuple.mapFirst (Model url key)


fromUrl : Url -> (Page, Cmd Msg)
fromUrl url =
  case Route.fromUrl url of
    Just Route.Home ->
      Page.Home.init
        |> Tuple.mapBoth Home (Cmd.map NavigatedToHome)

    Just (Route.Rental rentalId) ->
      Page.Rental.init rentalId
        |> Tuple.mapBoth Rental (Cmd.map NavigatedToRental)

    Just Route.About ->
      ( About
      , Cmd.none
      )

    Just Route.Contact ->
      ( Contact
      , Cmd.none
      )

    Nothing ->
      ( NotFound
      , Cmd.none
      )


-- UPDATE


type Msg
  = ClickedLink Browser.UrlRequest
  | ChangedUrl Url
  | NavigatedToHome Page.Home.Msg
  | NavigatedToRental Page.Rental.Msg


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
      fromUrl url
        |> Tuple.mapFirst (Model url model.key)

    NavigatedToHome homeMsg ->
      case model.page of
        Home homeModel ->
          ( { model | page = Home (Page.Home.update homeMsg homeModel) }
          , Cmd.none
          )

        _ ->
          ( model
          , Cmd.none
          )

    NavigatedToRental rentalMsg ->
      case model.page of
        Rental rentalModel ->
          ( { model | page = Rental (Page.Rental.update rentalMsg rentalModel) }
          , Cmd.none
          )

        _ ->
          ( model
          , Cmd.none
          )


-- VIEW


view : Model -> Browser.Document Msg
view { url, page } =
  { title = "Super Rentals"
  , body =
      [ div [ class "container" ]
          [ Widget.NavBar.view
          , div [ class "body" ] <|
              case page of
                Home homeModel ->
                  Page.Home.view homeModel
                    |> List.map (Html.map NavigatedToHome)

                Rental rentalModel ->
                  Page.Rental.view url rentalModel
                    |> List.map (Html.map NavigatedToRental)

                About ->
                  Page.About.view

                Contact ->
                  Page.Contact.view

                NotFound ->
                  [ text "Not found" ]
          ]
      ]
  }
