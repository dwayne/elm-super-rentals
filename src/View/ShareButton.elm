module View.ShareButton exposing (ViewOptions, view)

import Html as H
import Html.Attributes as HA
import Url exposing (Url)
import Url.Builder as UB


type alias ViewOptions msg =
    { url : Url
    , text : String
    , hashtags : String
    , via : String
    , attrs : List (H.Attribute msg)
    , content : H.Html msg
    }


view : ViewOptions msg -> H.Html msg
view { url, text, hashtags, via, attrs, content } =
    let
        postAttrs =
            [ HA.href <| shareUrl url text hashtags via
            , HA.target "_blank"
            , HA.rel "external nofollow noopener noreferrer"
            , HA.class "share button"
            ]
    in
    H.a (attrs ++ postAttrs) [ content ]


shareUrl : Url -> String -> String -> String -> String
shareUrl url text hashtags via =
    UB.crossOrigin "https://twitter.com"
        [ "intent", "tweet" ]
        [ UB.string "url" <| Url.toString url
        , UB.string "text" text
        , UB.string "hashtags" hashtags
        , UB.string "via" via
        ]
