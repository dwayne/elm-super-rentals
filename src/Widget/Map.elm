module Widget.Map exposing (Config, view)


import Html exposing (Attribute, Html, div, img)
import Html.Attributes exposing (alt, class, height, src, width)


type alias Config =
  { lat : Float
  , lng : Float
  , zoom : Int
  , width : Int
  , height : Int
  }


view : Config -> List (Attribute msg) -> Html msg
view config attrs =
  let
    preAttrs =
      [ alt <|
          String.join ""
            [ "Map image at coordinates "
            , String.fromFloat config.lat
            , ","
            , String.fromFloat config.lng
            ]
      ]

    postAttrs =
      [ src <|
          String.join ""
            [ "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/"
            , String.fromFloat config.lng
            , ","
            , String.fromFloat config.lat
            , ","
            , String.fromInt config.zoom
            , "/"
            , String.fromInt config.width
            , "x"
            , String.fromInt config.height
            , "@2x?access_token="
            , mapBoxAccessToken
            ]
      , width config.width
      , height config.height
      ]
  in
    div [ class "map" ]
      [ img (preAttrs ++ attrs ++ postAttrs) []
      ]


mapBoxAccessToken : String
mapBoxAccessToken =
  "pk.eyJ1IjoiZHdheW5lY3Jvb2tzIiwiYSI6ImNraDJlNmJ3cjA0OHEycnFkbjBsY2owbHMifQ.oMp9oQxaoLK0C4aSFwKEjw"
