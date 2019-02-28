# #FlutterCreate Run submission

This my submission for the [FlutterCreate](https://flutter.dev/create) contest which consist of creating a nice use experience in less that 5KB of code.

All the code is available in the [lib/main.dart file](lib/main.dart).

## Disclaimer

A lot of bad practices are used in this project since the most important factor here is the codebase size! Don't reproduce it in your regular projects, mainly :

* **Short naming** : a lot of variables are named with a few characters which doesn't make it easy to read.
* **`var` only**: use `final` keyword when your value isn't modified after its declaration
* **Accessing enums by index**: if the enumeration values order changes, you code wouldn't access the right values. 
* **`dynamic` by omitting type declaration**: precise all types when possible.
* **Functions for widgets** : Classes should be declared for widgets instead of functions (or use [functional_widget](https://github.com/rrousselGit/functional_widget) to generate them).
* **Accessing json properties with magic strings**: use code generators to generate serializers ([json_serializable](https://github.com/dart-lang/json_serializable)).
* **Everything in the view** : adopt an architectural pattern (like [BLoC](https://aloisdeniel.com/post/p9OCupX71qaLtGYHpnV0) or [scoped_model](https://github.com/brianegan/scoped_model)) to separate your concerns.
* **A single file** : use multiple files to simply code organization.

## Notes 

The prebaked [runs.json file](data/run.json) is generate with the [script](bin/points_gen.d).