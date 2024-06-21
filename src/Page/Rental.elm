module Page.Rental exposing (Model, Msg, init, update, view)

import Api
import Data.Rental exposing (Rental)
import Html as H
import Http
import Url exposing (Url)
import View.Jumbo
import View.RentalDetailed
import View.ShareButton



-- MODEL


type alias Model =
    { maybeRental : Maybe ( Rental, Bool )
    }


init : String -> ( Model, Cmd Msg )
init rentalId =
    ( Model Nothing
    , Api.fetchRental rentalId GotRental
    )



-- UPDATE


type Msg
    = GotRental (Result Http.Error Rental)
    | ToggledSize Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotRental result ->
            case result of
                Ok rental ->
                    { model | maybeRental = Just ( rental, False ) }

                Err e ->
                    model

        ToggledSize isLarge ->
            { model
                | maybeRental =
                    model.maybeRental
                        |> Maybe.map (\( rental, _ ) -> ( rental, isLarge ))
            }



-- VIEW


view : Url.Url -> Model -> List (H.Html Msg)
view url { maybeRental } =
    case maybeRental of
        Just ( rental, isLarge ) ->
            [ View.Jumbo.view
                [ H.h2 [] [ H.text rental.title ]
                , H.p []
                    [ H.text <| "Nice find! This looks like a nice place to stay near " ++ rental.city ++ "." ]
                , View.ShareButton.view
                    { url = url
                    , text = "Check out " ++ rental.title ++ " on Super Rentals!"
                    , hashtags = "vacation,travel,authentic,blessed,superrentals"
                    , via = "emberjs"
                    , attrs = []
                    , content = H.text "Share on Twitter"
                    }
                ]
            , View.RentalDetailed.view
                { rental = rental
                , isLarge = isLarge
                , onToggleSize = ToggledSize
                }
            ]

        Nothing ->
            [ H.text "" ]
