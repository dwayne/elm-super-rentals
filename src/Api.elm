module Api exposing (fetchRental, fetchRentals)


import Data exposing (Rental, Location)
import Http
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D


fetchRental : String -> (Result Http.Error Rental -> msg) -> Cmd msg
fetchRental id toMsg =
  Http.get
    { url = "/api/rentals/" ++ id ++ ".json"
    , expect = Http.expectJson toMsg (D.field "data" rentalDecoder)
    }


fetchRentals : (Result Http.Error (List Rental) -> msg) -> Cmd msg
fetchRentals toMsg =
  Http.get
    { url = "/api/rentals.json"
    , expect = Http.expectJson toMsg rentalsDecoder
    }


rentalsDecoder : Decoder (List Rental)
rentalsDecoder =
  D.field "data" (D.list rentalDecoder)


rentalDecoder : Decoder Rental
rentalDecoder =
  D.map
    (\partialRental ->
      { id = partialRental.id
      , title = partialRental.title
      , owner = partialRental.owner
      , city = partialRental.city
      , location = partialRental.location
      , category = partialRental.category
      , kind =
          case partialRental.category of
            "Condo" ->
              "Community"

            "Townhouse" ->
              "Community"

            "Apartment" ->
              "Community"

            _ ->
              "Standalone"
      , bedrooms = partialRental.bedrooms
      , image = partialRental.image
      , description = partialRental.description
      })
    partialRentalDecoder


type alias PartialRental =
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


partialRentalDecoder : Decoder PartialRental
partialRentalDecoder =
  D.succeed PartialRental
    |> D.required "id" D.string
    |> D.requiredAt ["attributes", "title"] D.string
    |> D.requiredAt ["attributes", "owner"] D.string
    |> D.requiredAt ["attributes", "city"] D.string
    |> D.requiredAt ["attributes", "location"] locationDecoder
    |> D.requiredAt ["attributes", "category"] D.string
    |> D.requiredAt ["attributes", "bedrooms"] D.int
    |> D.requiredAt ["attributes", "image"] D.string
    |> D.requiredAt ["attributes", "description"] D.string


locationDecoder : Decoder Location
locationDecoder =
  D.map2 Location
    (D.field "lat" D.float)
    (D.field "lng" D.float)
