module View.RentalImage exposing (ViewOptions, view)

import Html as H
import Html.Attributes as HA
import Html.Events as HE


type alias ViewOptions msg =
    { title : String
    , image : String
    , isLarge : Bool
    , onToggleSize : Bool -> msg
    }


view : ViewOptions msg -> H.Html msg
view { title, image, isLarge, onToggleSize } =
    let
        ( class, text ) =
            if isLarge then
                ( "image large"
                , "Smaller"
                )

            else
                ( "image"
                , "Larger"
                )
    in
    H.button
        [ HA.class class
        , HE.onClick <| onToggleSize <| not isLarge
        ]
        [ H.img
            [ HA.src image
            , HA.alt <| "A picture of " ++ title
            ]
            []
        , H.small [] [ H.text <| "View " ++ text ]
        ]
