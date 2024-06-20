module View.RentalImage exposing (ViewOptions, view)

import Html as H
import Html.Attributes as HA
import Html.Events as HE


type alias ViewOptions msg =
    { isLarge : Bool
    , onEnlargeClick : msg
    , onShrinkClick : msg
    , attrs : List (H.Attribute msg)
    }


view : ViewOptions msg -> H.Html msg
view { isLarge, onEnlargeClick, onShrinkClick, attrs } =
    let
        ( class, onClick, text ) =
            if isLarge then
                ( "image large"
                , onShrinkClick
                , "Smaller"
                )

            else
                ( "image"
                , onEnlargeClick
                , "Larger"
                )
    in
    H.button
        [ HA.class class
        , HE.onClick onClick
        ]
        [ H.img attrs []
        , H.small [] [ H.text <| "View " ++ text ]
        ]
