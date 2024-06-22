module View.TwitterButton exposing (ViewOptions, view)

import Html as H
import Html.Attributes as HA
import Url exposing (Url)
import Url.Builder as UB


type alias ViewOptions =
    { description : String
    , url : Url
    }


view : ViewOptions -> H.Html msg
view { description, url } =
    H.a
        [ HA.href <| shareUrl description url
        , HA.target "_blank"
        , HA.rel "external nofollow noopener noreferrer"
        , HA.class "share button"
        ]
        [ H.text "Share on Twitter" ]


shareUrl : String -> Url -> String
shareUrl description url =
    UB.crossOrigin "https://twitter.com"
        [ "intent", "tweet" ]
        [ UB.string "url" <| Url.toString url
        , UB.string "text" <| "Check out " ++ description ++ " on Super Rentals!"
        , UB.string "hashtags" "vacation,travel,authentic,blessed,superrentals"
        , UB.string "via" "elm"
        ]
