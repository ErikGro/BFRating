# BFRating

[![Version](https://img.shields.io/cocoapods/v/BFRating.svg?style=flat)](https://cocoapods.org/pods/BFRating)
[![License](https://img.shields.io/cocoapods/l/BFRating.svg?style=flat)](https://cocoapods.org/pods/BFRating)
[![Platform](https://img.shields.io/cocoapods/p/BFRating.svg?style=flat)](https://cocoapods.org/pods/BFRating)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

Before you start we can recommend to read the [bloc article](https://www.bitfactory.io/de/blog/inapp-rating/). Here we describe the basic workflow of BFRating.

### Use it!

First you have to initialize the RatingProvider. Then you can call the `showRatingDialog()` function from any `UIViewController`.
```swift
let ratingProvider = RatingProvider(controller: self, tintColor: .green) //Default value UIColor.blue

// Customize alert directly in function
ratingProvider.showRatingDialog(afterDays: 10, afterViewCount: 3, onYesFeedback: nil, onLaterFeedback: nil) {
    //Eg. show MFMailComposeViewController to get user feedback
}
```
There is also a `reset()` function to go back to a clean state.

You can also call rating dialog with `showRatingDialogOnClick()` to show it when user clicks on button. 
```swift
// Call rating dialog
ratingProvider.showRatingDialogOnClick(onYesFeedback: {
    // Do something here
}, onLaterFeedback: {
    // Ask user to rate app again later
}, onNoFeedback: {
    // Open support chat or
    // show MFMailComposeViewController to get user feedback
})
```

You can set up an array of custom variables, to let rating provider appear after variables gets valid values.
```swift
// Call rating dialog after custom values
let gamePlayed = 3
let boughtItems = 1

ratingProvider.showRatingDialog(customValues: [gamePlayed, boughtItems], onLaterFeedback: {
// Reset user values
    ratingProvider.resetUserValues()
}, onNoFeedback: {
    // Show support chat and reset user values
    ratingProvider.resetUserValues()
})

// F.e. user has played 3 games and bought 1 item
// Set values with function:

ratingProvider.setUserValues([3, 1])
// Then ratingProvider.showRatingDialogAfterCustomValue will be called
}
```
`resetUserValues()` function will reset uservalues to [].

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
