module Data.Rental exposing (Rental, toKind)

import Data.Location exposing (Location)


type alias Rental =
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


toKind : Rental -> String
toKind { category } =
    case category of
        "Condo" ->
            "Community"

        "Townhouse" ->
            "Community"

        "Apartment" ->
            "Community"

        _ ->
            "Standalone"
