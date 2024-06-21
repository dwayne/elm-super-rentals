module View.Map exposing (ViewOptions, view)

import Html as H
import Html.Attributes as HA


type alias ViewOptions =
    { description : String
    , isLarge : Bool
    , lat : Float
    , lng : Float
    , zoom : Int
    , width : Int
    , height : Int
    }


view : ViewOptions -> H.Html msg
view { description, isLarge, lat, lng, zoom, width, height } =
    H.div [ HA.class "map" ]
        [ H.img
            [ HA.classList [ ( "large", isLarge ) ]
            , HA.alt <| "A map of " ++ description
            , HA.src <|
                String.join ""
                    [ "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/"
                    , String.fromFloat lng
                    , ","
                    , String.fromFloat lat
                    , ","
                    , String.fromInt zoom
                    , "/"
                    , String.fromInt width
                    , "x"
                    , String.fromInt height
                    , "@2x?access_token="
                    , mapBoxAccessToken
                    ]
            , HA.width width
            , HA.height height
            ]
            []
        ]


mapBoxAccessToken : String
mapBoxAccessToken =
    "pk.eyJ1IjoiZHdheW5lY3Jvb2tzIiwiYSI6ImNraDJlNmJ3cjA0OHEycnFkbjBsY2owbHMifQ.oMp9oQxaoLK0C4aSFwKEjw"
