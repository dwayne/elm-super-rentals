module Page.Home exposing (Model, Msg, init, update, view)

import Api
import Data.Rental exposing (Rental)
import Data.Route as Route
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Http
import View.Jumbo
import View.LinkTo
import View.Rental



-- MODEL


type alias Model =
    { rentals : List ( Rental, Bool )
    , query : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] ""
    , Api.fetchRentals GotRentals
    )



-- UPDATE


type Msg
    = GotRentals (Result Http.Error (List Rental))
    | ToggledSize String Bool
    | ChangedQuery String


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotRentals result ->
            case result of
                Ok rentals ->
                    { model | rentals = List.map (\rental -> ( rental, False )) rentals }

                Err _ ->
                    model

        ToggledSize id isLarge ->
            { model
                | rentals =
                    List.map
                        (\( rental, current ) ->
                            if id == rental.id then
                                ( rental, isLarge )

                            else
                                ( rental, current )
                        )
                        model.rentals
            }

        ChangedQuery query ->
            { model | query = query }



-- VIEW


view : Model -> List (H.Html Msg)
view { rentals, query } =
    [ View.Jumbo.view
        [ H.h2 [] [ H.text "Welcome to Super Rentals!" ]
        , H.p [] [ H.text "We hope you find exactly what you're looking for in a place to stay." ]
        , View.LinkTo.view
            { route = Route.About
            , text = "About Us"
            }
        ]
    , H.div [ HA.class "rentals" ]
        [ H.label []
            [ H.span [] [ H.text "Where would you like to stay?" ]
            , H.input
                [ HA.class "light"
                , HA.value query
                , HE.onInput ChangedQuery
                ]
                []
            ]
        , rentals
            |> filter query
            |> List.map viewRental
            |> H.ul [ HA.class "results" ]
        ]
    ]


viewRental : ( Rental, Bool ) -> H.Html Msg
viewRental ( rental, isLarge ) =
    H.li []
        [ View.Rental.view
            { rental = rental
            , isLarge = isLarge
            , onToggleSize = ToggledSize rental.id
            }
        ]


filter : String -> List ( Rental, Bool ) -> List ( Rental, Bool )
filter query =
    List.filter (Tuple.first >> .title >> String.contains query)
