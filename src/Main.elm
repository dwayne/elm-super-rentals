module Main exposing (main)


import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
import Url

import Route exposing (Route)


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
  , route : Route
  , rentals : List (Bool, Rental)
  , rental : Maybe Rental
  }


init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key =
  ( Model key (Route.fromUrl url) [] Nothing
  , fetchRentals
  )


-- UPDATE


type Msg
  = ClickedLink Browser.UrlRequest
  | ChangedUrl Url.Url
  | ClickedToggleSize Int Bool
  | GotRentals (Result Http.Error (List Rental))
  | GotRental (Result Http.Error Rental)


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
      let
        newRoute =
          Route.fromUrl url
      in
        ( { model | route = newRoute }
        , case newRoute of
            Route.Home ->
              fetchRentals

            Route.Rental rentalId ->
              fetchRental rentalId

            _ ->
              Cmd.none
        )

    ClickedToggleSize i isLarge ->
      ( { model
        | rentals =
            List.indexedMap
              (\j (current, rental) ->
                if i == j then
                  (isLarge, rental)
                else
                  (current, rental))
              model.rentals
        }
      , Cmd.none
      )

    GotRentals (Ok rentals) ->
      ( { model | rentals = List.map (\rental -> (False, rental)) rentals }
      , Cmd.none
      )

    GotRentals (Err e) ->
      ( Debug.log ("Got error: " ++ Debug.toString e) model
      , Cmd.none
      )

    GotRental (Ok rental) ->
      ( { model | rental = Just rental }
      , Cmd.none
      )

    GotRental (Err e) ->
      ( Debug.log ("Got error: " ++ Debug.toString e) model
      , Cmd.none
      )


-- VIEW


view : Model -> Browser.Document Msg
view { route, rentals } =
  { title = "Super Rentals"
  , body = [ viewApplication route rentals ]
  }


viewApplication : Route -> List (Bool, Rental) -> Html Msg
viewApplication route rentals =
  div [ class "container" ]
    [ viewNavBar
    , div [ class "body" ] <|
        case route of
          Route.Home ->
            viewHome rentals

          Route.Rental rentalId ->
            [ text ("You're viewing: " ++ rentalId) ]

          Route.About ->
            viewAbout

          Route.Contact ->
            viewContact

          Route.NotFound ->
            viewNotFound
    ]


viewHome : List (Bool, Rental) -> List (Html Msg)
viewHome rentals =
  [ viewJumbo
      [ h2 [] [ text "Welcome to Super Rentals!" ]
      , p [] [ text "We hope you find exactly what you're looking for in a place to stay." ]
      , a [ href "/about", class "button" ] [ text "About Us" ]
      ]
  , div [ class "rentals" ]
      [ ul [ class "results" ] <|
          List.indexedMap
            (\i (isLarge, rental) ->
              li [] [ viewRental i isLarge rental ])
            rentals
      ]
  ]


viewAbout : List (Html msg)
viewAbout =
  [ viewJumbo
      [ h2 [] [ text "About Super Rentals" ]
      , p [] [ text "The Super Rentals website is a delightful project created to explore Ember. By building a property rental site, we can simultaneously imagine traveling AND building Ember applications." ]
      , a [ href "/getting-in-touch", class "button" ] [ text "Contact Us" ]
      ]
  ]


viewContact : List (Html msg)
viewContact =
  [ viewJumbo
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
  ]


viewNotFound : List (Html msg)
viewNotFound =
  [ text "Not found"
  ]


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


-- RENTAL


type alias Rental =
  { id : String
  , title : String
  , owner : String
  , city : String
  , location : Location
  , category : String
  , kind : String
  , bedrooms : Int
  , image : String
  , description : String
  }


type alias Location =
  { lat : Float
  , lng : Float
  }


viewRental : Int -> Bool -> Rental -> Html Msg
viewRental index isLarge rental =
  article [ class "rental" ]
    [ viewRentalImage
        index
        isLarge
        [ src rental.image
        , alt ("A picture of " ++ rental.title)
        ]
    , div [ class "details" ]
        [ h3 []
            [ a [ href ("/rentals/" ++ rental.id) ] [ text rental.title ]
            ]
        , div [ class "detail owner" ]
            [ span [] [ text "Owner:" ]
            , text " "
            , text rental.owner
            ]
        , div [ class "detail type" ]
            [ span [] [ text "Type:" ]
            , text " "
            , text rental.kind
            ]
        , div [ class "detail location" ]
            [ span [] [ text "Location:" ]
            , text " "
            , text rental.city
            ]
        , div [ class "detail bedrooms" ]
            [ span [] [ text "Number of bedrooms:" ]
            , text " "
            , text (String.fromInt rental.bedrooms)
            ]
        ]
    , viewMap
        { lat = rental.location.lat
        , lng = rental.location.lng
        , zoom = 9
        , width = 150
        , height = 150
        }
        [ alt ("A map of " ++ rental.title) ]
    ]


viewRentalImage : Int -> Bool -> List (Attribute Msg) -> Html Msg
viewRentalImage index isLarge attrs =
  if isLarge then
    button [ class "image large", onClick (ClickedToggleSize index False) ]
      [ img attrs
          []
      , small [] [ text "View Smaller" ]
      ]
  else
    button [ class "image", onClick (ClickedToggleSize index True) ]
      [ img attrs
          []
      , small [] [ text "View Larger" ]
      ]


-- MAP


type alias MapConfig =
  { lat : Float
  , lng : Float
  , zoom : Int
  , width : Int
  , height : Int
  }


viewMap : MapConfig -> List (Attribute msg) -> Html msg
viewMap config attrs =
  let
    preAttrs =
      [ alt <|
          String.join ""
            [ "Map image at coordinates "
            , String.fromFloat config.lat
            , ","
            , String.fromFloat config.lng
            ]
      ]

    postAttrs =
      [ src <|
          String.join ""
            [ "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/"
            , String.fromFloat config.lng
            , ","
            , String.fromFloat config.lat
            , ","
            , String.fromInt config.zoom
            , "/"
            , String.fromInt config.width
            , "x"
            , String.fromInt config.height
            , "@2x?access_token="
            , mapBoxAccessToken
            ]
      , width config.width
      , height config.height
      ]
  in
    div [ class "map" ]
      [ img (preAttrs ++ attrs ++ postAttrs) []
      ]


mapBoxAccessToken : String
mapBoxAccessToken =
  "pk.eyJ1IjoiZHdheW5lY3Jvb2tzIiwiYSI6ImNraDJlNmJ3cjA0OHEycnFkbjBsY2owbHMifQ.oMp9oQxaoLK0C4aSFwKEjw"


-- API


fetchRental : String -> Cmd Msg
fetchRental id =
  Http.get
    { url = "http://localhost:8000/api/rentals/" ++ id ++ ".json"
    , expect = Http.expectJson GotRental (D.field "data" rentalDecoder)
    }


fetchRentals : Cmd Msg
fetchRentals =
  Http.get
    { url = "http://localhost:8000/api/rentals.json"
    , expect = Http.expectJson GotRentals rentalsDecoder
    }


rentalsDecoder : Decoder (List Rental)
rentalsDecoder =
  D.field "data" (D.list rentalDecoder)


rentalDecoder : Decoder Rental
rentalDecoder =
  D.map
    (\partialRental ->
      { id = partialRental.id
      , title = partialRental.title
      , owner = partialRental.owner
      , city = partialRental.city
      , location = partialRental.location
      , category = partialRental.category
      , kind =
          case partialRental.category of
            "Condo" ->
              "Community"

            "Townhouse" ->
              "Community"

            "Apartment" ->
              "Community"

            _ ->
              "Standalone"
      , bedrooms = partialRental.bedrooms
      , image = partialRental.image
      , description = partialRental.description
      })
    partialRentalDecoder


type alias PartialRental =
  { id : String
  , title : String
  , owner : String
  , city : String
  , location : Location
  , category : String
  , bedrooms : Int
  , image : String
  , description : String
  }


partialRentalDecoder : Decoder PartialRental
partialRentalDecoder =
  D.succeed PartialRental
    |> D.required "id" D.string
    |> D.requiredAt ["attributes", "title"] D.string
    |> D.requiredAt ["attributes", "owner"] D.string
    |> D.requiredAt ["attributes", "city"] D.string
    |> D.requiredAt ["attributes", "location"] locationDecoder
    |> D.requiredAt ["attributes", "category"] D.string
    |> D.requiredAt ["attributes", "bedrooms"] D.int
    |> D.requiredAt ["attributes", "image"] D.string
    |> D.requiredAt ["attributes", "description"] D.string


locationDecoder : Decoder Location
locationDecoder =
  D.map2 Location
    (D.field "lat" D.float)
    (D.field "lng" D.float)
