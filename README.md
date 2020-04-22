# FreakyTicTacToe
A very simple tic-tac-toe game view implemented in Objective-C using `GameplayKit`.

The game can be generalized to an *m,n,k*-game since already supports dynamic square board (so it is assumed that *m* = *n*) via `size` property and *k*-in-a-row marks via `marks` property.

`TicTacToeGameView` is a `UIView` subclass and use `GameplayKit` framework to implement artificial intelligence.

## Installation
Manually add files from `TicTacToeGameView` directory into your project.

## Usage
Import `TicTacToeGameView.h` header and implement `GameViewDelegate` protocol.

You can run the example project and see `ViewController` class for an example of how to use `TicTacToeGameView`.

### Notes
Please notice that this view is used inside an existing app and I had to reuse existing class hierarchy, enums, prefix header constants, etc.

## Author
Enrico Angelini, info@spirales.it

## License
This software is available under the MIT license. See the LICENSE file for more info.
