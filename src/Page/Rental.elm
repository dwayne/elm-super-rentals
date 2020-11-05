module Page.Rental exposing (Model, init, Msg, update, view)


import Api
import Data exposing (Rental)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Url
import Widget.Jumbo
import Widget.RentalDetailed
import Widget.ShareButton


-- MODEL


type alias Model =
  { maybeRental : Maybe (Bool, Rental)
  }


init : String -> (Model, Cmd Msg)
init rentalId =
  ( Model Nothing
  , Api.fetchRental rentalId GotRental
  )


-- UPDATE


type Msg
  = ClickedToggleSize Bool
  | GotRental (Result Http.Error Rental)


update : Msg -> Model -> Model
update msg model =
  case msg of
    ClickedToggleSize isLarge ->
      { model
      | maybeRental =
          model.maybeRental
            |> Maybe.map (\(_, rental) -> (isLarge, rental))
      }

    GotRental (Ok rental) ->
      { model | maybeRental = Just (False, rental) }

    GotRental (Err e) ->
      Debug.log ("Got error: " ++ Debug.toString e) model


-- VIEW


view : Url.Url -> Model -> List (Html Msg)
view url { maybeRental } =
  case maybeRental of
    Nothing ->
      [ text "" ]

    Just (isLarge, rental) ->
      [ Widget.Jumbo.view
          [ h2 [] [ text rental.title ]
          , p []
              [ text ("Nice find! This looks like a nice place to stay near " ++ rental.city ++ ".") ]
          , Widget.ShareButton.view
              { url = url
              , text = "Check out " ++ rental.title ++ " on Super Rentals!"
              , hashtags = "vacation,travel,authentic,blessed,superrentals"
              , via = "emberjs"
              }
              []
              (text "Share on Twitter")
          ]
      , Widget.RentalDetailed.view
          isLarge
          rental
          ClickedToggleSize
      ]
