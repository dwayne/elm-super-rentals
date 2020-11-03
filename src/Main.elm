module Main exposing (main)


import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
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
  , rentalImageStates : List Bool
  }


init : () -> Url.Url -> Nav.Key -> (Model, Cmd msg)
init _ url key =
  ( Model url key [ False, False, False ]
  , Cmd.none
  )


-- UPDATE


type Msg
  = ClickedLink Browser.UrlRequest
  | ChangedUrl Url.Url
  | ClickedToggleSize Int Bool


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

    ClickedToggleSize i isLarge ->
      ( { model
        | rentalImageStates =
            List.indexedMap
              (\j prev -> if i == j then isLarge else prev)
              model.rentalImageStates
        }
      , Cmd.none
      )


-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "Super Rentals"
  , body = [ viewApplication model.url model.rentalImageStates ]
  }


viewApplication : Url.Url -> List Bool -> Html Msg
viewApplication url rentalImageStates =
  div [ class "container" ]
    [ viewNavBar
    , div [ class "body" ] <|
        case Route.fromUrl url of
          Home ->
            viewHome rentalImageStates

          About ->
            viewAbout

          Contact ->
            viewContact

          NotFound ->
            viewNotFound
    ]


viewHome : List Bool -> List (Html Msg)
viewHome rentalImageStates =
  [ viewJumbo
      [ h2 [] [ text "Welcome to Super Rentals!" ]
      , p [] [ text "We hope you find exactly what you're looking for in a place to stay." ]
      , a [ href "/about", class "button" ] [ text "About Us" ]
      ]
  , div [ class "rentals" ]
      [ ul [ class "results" ] <|
          List.indexedMap (\i isLarge -> li [] [ viewRental i isLarge ]) rentalImageStates
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


viewRental : Int -> Bool -> Html Msg
viewRental index isLarge =
  article [ class "rental" ]
    [ viewRentalImage
        index
        isLarge
        [ src "https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg"
        , alt "A picture of Grand Old Mansion"
        ]
    , div [ class "details" ]
        [ h3 [] [ text "Grand Old Mansion" ]
        , div [ class "detail owner" ]
            [ span [] [ text "Owner:" ]
            , text " "
            , text "Veruca Salt"
            ]
        , div [ class "detail type" ]
            [ span [] [ text "Type:" ]
            , text " "
            , text "Standalone"
            ]
        , div [ class "detail location" ]
            [ span [] [ text "Location:" ]
            , text " "
            , text "San Francisco"
            ]
        , div [ class "detail bedrooms" ]
            [ span [] [ text "Number of bedrooms:" ]
            , text " "
            , text "15"
            ]
        ]
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
