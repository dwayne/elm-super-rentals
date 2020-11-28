module Widget.ShareButton exposing (Config, view)


import Html exposing (Attribute, Html, a)
import Html.Attributes exposing (class, href, rel, target)
import Url exposing (Url)
import Url.Builder exposing (crossOrigin, string)


type alias Config =
  { url : Url
  , text : String
  , hashtags : String
  , via : String
  }


view : Config -> List (Attribute msg) -> Html msg -> Html msg
view config attrs content =
  let
    postAttrs =
      [ href (shareUrl config)
      , target "_blank"
      , rel "external nofollow noopener noreferrer"
      , class "share button"
      ]
  in
    a (attrs ++ postAttrs) [ content ]


shareUrl : Config -> String
shareUrl config =
  crossOrigin "https://twitter.com"
    [ "intent", "tweet" ]
    [ string "url" (Url.toString config.url)
    , string "text" config.text
    , string "hashtags" config.hashtags
    , string "via" config.via
    ]
