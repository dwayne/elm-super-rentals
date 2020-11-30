module Page.Home exposing (Model, init, Msg, update, view)


import Api
import Data exposing (Rental)
import Html exposing (Html, a, div, h2, input, label, li, p, span, text, ul)
import Html.Attributes exposing (class, href, value)
import Html.Events as E
import Http
import Route
import Widget.Jumbo
import Widget.Rental


-- MODEL


type alias Model =
  { rentals : List (Rental, Bool)
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
            (\j (rental, current) ->
              if i == j then
                (rental, isLarge)
              else
                (rental, current))
            model.rentals
      }

    ChangedQuery query ->
      { model | query = query }

    GotRentals (Ok rentals) ->
      { model | rentals = List.map (\rental -> (rental, False)) rentals }

    GotRentals (Err e) ->
      model


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
              [ E.onInput ChangedQuery
              , value query
              , class "light"
              ]
              []
          ]
      , ul [ class "results" ] <|
          List.indexedMap viewRental (filterRentals query rentals)
      ]
  ]


viewRental : Int -> (Rental, Bool) -> Html Msg
viewRental index (rental, isLarge) =
  li []
    [ Widget.Rental.view
        (ClickedToggleSize index True)
        (ClickedToggleSize index False)
        isLarge
        rental
    ]


filterRentals : String -> List (Rental, Bool) -> List (Rental, Bool)
filterRentals query rentals =
  List.filter (\(rental, _) -> String.contains query rental.title) rentals
