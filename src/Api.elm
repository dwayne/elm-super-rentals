module Api exposing (fetchRental, fetchRentals)

import Data.Location exposing (Location)
import Data.Rental exposing (Rental)
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JD


fetchRental : String -> (Result Http.Error Rental -> msg) -> Cmd msg
fetchRental id toMsg =
    Http.get
        { url = "/api/rentals/" ++ id ++ ".json"
        , expect = Http.expectJson toMsg (JD.field "data" rentalDecoder)
        }


fetchRentals : (Result Http.Error (List Rental) -> msg) -> Cmd msg
fetchRentals toMsg =
    Http.get
        { url = "/api/rentals.json"
        , expect = Http.expectJson toMsg rentalsDecoder
        }


rentalsDecoder : JD.Decoder (List Rental)
rentalsDecoder =
    JD.field "data" (JD.list rentalDecoder)


rentalDecoder : JD.Decoder Rental
rentalDecoder =
    JD.map
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
            }
        )
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


partialRentalDecoder : JD.Decoder PartialRental
partialRentalDecoder =
    JD.succeed PartialRental
        |> JD.required "id" JD.string
        |> JD.requiredAt [ "attributes", "title" ] JD.string
        |> JD.requiredAt [ "attributes", "owner" ] JD.string
        |> JD.requiredAt [ "attributes", "city" ] JD.string
        |> JD.requiredAt [ "attributes", "location" ] locationDecoder
        |> JD.requiredAt [ "attributes", "category" ] JD.string
        |> JD.requiredAt [ "attributes", "bedrooms" ] JD.int
        |> JD.requiredAt [ "attributes", "image" ] JD.string
        |> JD.requiredAt [ "attributes", "description" ] JD.string


locationDecoder : JD.Decoder Location
locationDecoder =
    JD.map2 Location
        (JD.field "lat" JD.float)
        (JD.field "lng" JD.float)
