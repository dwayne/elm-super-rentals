module Page exposing (Page, fromRoute, Msg, update, view)


import Html exposing (..)
import Html.Attributes exposing (..)
import Page.About
import Page.Contact
import Page.Home
import Page.Rental
import Route exposing (Route)
import Widget.NavBar


-- MODEL


type Page
  = Home Page.Home.Model
  | Rental String Page.Rental.Model
  | About
  | Contact
  | NotFound


fromRoute : Route -> (Page, Cmd Msg)
fromRoute route =
  case route of
    Route.Home ->
      Page.Home.init
        |> Tuple.mapBoth Home (Cmd.map GotHome)

    Route.Rental rentalId ->
      Page.Rental.init rentalId
        |> Tuple.mapBoth (Rental rentalId) (Cmd.map GotRental)

    Route.About ->
      ( About
      , Cmd.none
      )

    Route.Contact ->
      ( Contact
      , Cmd.none
      )

    Route.NotFound ->
      ( NotFound
      , Cmd.none
      )


-- UPDATE


type Msg
  = GotHome Page.Home.Msg
  | GotRental Page.Rental.Msg


update : Msg -> Page -> Page
update msg page =
  case msg of
    GotHome homeMsg ->
      case page of
        Home homeModel ->
          Home (Page.Home.update homeMsg homeModel)

        _ ->
          page

    GotRental rentalMsg ->
      case page of
        Rental rentalId rentalModel ->
          Rental rentalId (Page.Rental.update rentalMsg rentalModel)

        _ ->
          page


-- VIEW


view : Page -> List (Html Msg)
view page =
  [ div [ class "container" ]
      [ Widget.NavBar.view
      , div [ class "body" ] <|
          case page of
            Home homeModel ->
              Page.Home.view homeModel
                |> List.map (Html.map GotHome)

            Rental _ rentalModel ->
              Page.Rental.view rentalModel
                |> List.map (Html.map GotRental)

            About ->
              Page.About.view

            Contact ->
              Page.Contact.view

            NotFound ->
              [ text "Not found" ]
      ]
  ]
