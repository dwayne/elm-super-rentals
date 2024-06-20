module View.Map exposing (ViewOptions, view)

import Html as H
import Html.Attributes as HA


type alias ViewOptions msg =
    { lat : Float
    , lng : Float
    , zoom : Int
    , width : Int
    , height : Int
    , attrs : List (H.Attribute msg)
    }


view : ViewOptions msg -> H.Html msg
view { lat, lng, zoom, width, height, attrs } =
    let
        preAttrs =
            [ HA.alt <|
                String.join ""
                    [ "Map image at coordinates "
                    , String.fromFloat lat
                    , ","
                    , String.fromFloat lng
                    ]
            ]

        postAttrs =
            [ HA.src <|
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
    in
    H.div [ HA.class "map" ]
        [ H.img (preAttrs ++ attrs ++ postAttrs) []
        ]


mapBoxAccessToken : String
mapBoxAccessToken =
    "pk.eyJ1IjoiZHdheW5lY3Jvb2tzIiwiYSI6ImNraDJlNmJ3cjA0OHEycnFkbjBsY2owbHMifQ.oMp9oQxaoLK0C4aSFwKEjw"
