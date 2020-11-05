module Page.Home exposing (Model, init, Msg, update, view)


import Api
import Data exposing (Rental)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import Route
import Widget.Jumbo
import Widget.Rental


-- MODEL


type alias Model =
  { rentals : List (Bool, Rental)
  , query : String
  }


init : (Model, Cmd Msg)
init =
  ( Model [] ""
  , Api.fetchRentals GotRentals
  )


-- UPDATE


type Msg
  = ClickedToggleSize Int Bool
  | ChangedQuery String
  | GotRentals (Result Http.Error (List Rental))


update : Msg -> Model -> Model
update msg model =
  case msg of
    ClickedToggleSize i isLarge ->
      { model
      | rentals =
          List.indexedMap
            (\j (current, rental) ->
              if i == j then
                (isLarge, rental)
              else
                (current, rental))
            model.rentals
      }

    ChangedQuery query ->
      { model | query = query }

    GotRentals (Ok rentals) ->
      { model | rentals = List.map (\rental -> (False, rental)) rentals }

    GotRentals (Err e) ->
      Debug.log ("Got error: " ++ Debug.toString e) model


-- VIEW


view : Model -> List (Html Msg)
view { rentals, query } =
  [ Widget.Jumbo.view
      [ h2 [] [ text "Welcome to Super Rentals!" ]
      , p [] [ text "We hope you find exactly what you're looking for in a place to stay." ]
      , a [ href (Route.href Route.About), class "button" ] [ text "About Us" ]
      ]
  , div [ class "rentals" ]
      [ label []
          [ span [] [ text "Where would you like to stay?" ]
          , input
              [ onInput ChangedQuery
              , value query
              , class "light"
              ]
              []
          ]
      , ul [ class "results" ] <|
          List.indexedMap
            (\i (isLarge, rental) ->
              li [] [ Widget.Rental.view isLarge rental (ClickedToggleSize i) ])
            rentals
      ]
  ]
