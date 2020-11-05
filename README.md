# Super Rentals - [Live Demo](https://elm-super-rentals.dwaynecrooks.com/)

An [Elm](https://elm-lang.org/) implementation of the
[Ember Tutorial](https://guides.emberjs.com/release/tutorial/)'s
"Super Rentals" web application.

## Learn

You can learn how the app was built by going through the commits one by one.

Each section of the Ember Tutorial is represented by a tag. So for e.g. the
section in Part 2 on "[Service Injection](https://guides.emberjs.com/release/tutorial/part-2/service-injection/)"
is implemented
[here](https://github.com/dwayne/elm-super-rentals/compare/route-params...service-injection)
in 6 commits. This is the point where I introduced [pages](https://github.com/dwayne/elm-super-rentals/tree/master/src/Page)
and [widgets](https://github.com/dwayne/elm-super-rentals/tree/master/src/Widget). In the
[6th commit](https://github.com/dwayne/elm-super-rentals/commit/ebb0a214761d676e6d404701cbb6ca2483598148)
I implemented the share button.

## Observations

- Ember has a lot of superfluous concepts to learn. They're not hard but they do
  seem unwarranted in the light of Elm
- Proper use of modules, type aliases, custom types and functions can take you
  very far
- Evan's advice [here](https://guide.elm-lang.org/webapps/structure.html) is
  right on point
- Incrementally building your app by adding one feature at a time can lead to
  a delightful architecture
