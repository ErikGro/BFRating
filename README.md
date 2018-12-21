# BFRating

[![Version](https://img.shields.io/cocoapods/v/BFRating.svg?style=flat)](https://cocoapods.org/pods/BFRating)
[![License](https://img.shields.io/cocoapods/l/BFRating.svg?style=flat)](https://cocoapods.org/pods/BFRating)
[![Platform](https://img.shields.io/cocoapods/p/BFRating.svg?style=flat)](https://cocoapods.org/pods/BFRating)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

Before you start we can recommend to read the [bloc article](https://www.bitfactory.io/de/blog/inapp-rating/). Here we describe the basic workflow of BFRating.

### Use it!

First you have to initialize the RatingProvider. Then you can call the `show()` function from any `UIViewController`:

```swift
let ratingProvider = RatingProvider()
ratingProvider.alertTintColor = UIColor.green //Default value UIColor.blue
ratingProvider.showAfterDays = 10 // Default value 14
ratingProvider.showAfterViewCount = 3 // Default value 5
ratingProvider.show(self) {
    //Eg. show MFMailComposeViewController to get user feedback
}
```

There is also a `reset()` function to go back to a clean state.

## Installation

BFRating is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BFRating'
```

## Author

Matthias Nagel, matthias@bitfactory.io

## License

BFRating is available under the MIT license. See the LICENSE file for more info.
