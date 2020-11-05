module Data exposing (Rental, Location)


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
