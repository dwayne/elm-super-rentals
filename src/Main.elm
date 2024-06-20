module Main exposing (main)

import Browser as B
import Browser.Navigation as BN
import Data.Route as Route exposing (Route)
import Html as H
import Html.Attributes as HA
import Page.About
import Page.Contact
import Page.Home
import Page.NotFound
import Page.Rental
import Url exposing (Url)
import View.NavBar


main : Program () Model Msg
main =
    B.application
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
    , key : BN.Key
    , page : Page
    }


type Page
    = Home Page.Home.Model
    | Rental Page.Rental.Model
    | About
    | Contact
    | NotFound


init : () -> Url -> BN.Key -> ( Model, Cmd Msg )
init _ url key =
    fromUrl url
        |> Tuple.mapFirst (Model url key)


fromUrl : Url -> ( Page, Cmd Msg )
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
    = ClickedLink B.UrlRequest
    | ChangedUrl Url
    | NavigatedToHome Page.Home.Msg
    | NavigatedToRental Page.Rental.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink urlRequest ->
            case urlRequest of
                B.Internal url ->
                    ( model
                    , BN.pushUrl model.key (Url.toString url)
                    )

                B.External href ->
                    ( model
                    , BN.load href
                    )

        ChangedUrl url ->
            fromUrl url
                |> Tuple.mapFirst (Model url model.key)

        NavigatedToHome homeMsg ->
            case model.page of
                Home homeModel ->
                    ( { model | page = Home <| Page.Home.update homeMsg homeModel }
                    , Cmd.none
                    )

                _ ->
                    ( model
                    , Cmd.none
                    )

        NavigatedToRental rentalMsg ->
            case model.page of
                Rental rentalModel ->
                    ( { model | page = Rental <| Page.Rental.update rentalMsg rentalModel }
                    , Cmd.none
                    )

                _ ->
                    ( model
                    , Cmd.none
                    )



-- VIEW


view : Model -> B.Document Msg
view { url, page } =
    { title = "Super Rentals"
    , body =
        [ H.div [ HA.class "container" ]
            [ View.NavBar.view
            , H.div [ HA.class "body" ] <|
                case page of
                    Home homeModel ->
                        Page.Home.view homeModel
                            |> List.map (H.map NavigatedToHome)

                    Rental rentalModel ->
                        Page.Rental.view url rentalModel
                            |> List.map (H.map NavigatedToRental)

                    About ->
                        Page.About.view

                    Contact ->
                        Page.Contact.view

                    NotFound ->
                        Page.NotFound.view
            ]
        ]
    }
