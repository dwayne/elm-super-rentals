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
    | ToggledSize Int Bool
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

        --
        -- TODO: Use the rental's ID instead of its position in the list.
        --
        ToggledSize i isLarge ->
            { model
                | rentals =
                    List.indexedMap
                        (\j ( rental, current ) ->
                            if i == j then
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
        , H.ul [ HA.class "results" ] <|
            List.indexedMap viewRental (filterRentals query rentals)
        ]
    ]


viewRental : Int -> ( Rental, Bool ) -> H.Html Msg
viewRental index ( rental, isLarge ) =
    H.li []
        [ View.Rental.view
            { isLarge = isLarge
            , onToggleSize = ToggledSize index
            , rental = rental
            }
        ]


filterRentals : String -> List ( Rental, Bool ) -> List ( Rental, Bool )
filterRentals query =
    List.filter (\( { title }, _ ) -> String.contains query title)
