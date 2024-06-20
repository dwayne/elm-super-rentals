module Data.Rental exposing (Rental)

import Data.Location exposing (Location)


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
