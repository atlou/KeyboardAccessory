# KeyboardAccessory

## Problem

In SwiftUI, there is this bug where a bottom view will not follow the interactive dismissal of the keyboard. 

<img align="center" src="https://github.com/user-attachments/assets/3686d2ea-3d56-4e0e-9ff9-1d8ea44b4d74" alt="Screenshot of the problem" width="25%">

## Solution 

Using this package, we can solve this problem and achieve the expected behavior.

<img align="center" src="https://github.com/user-attachments/assets/1f7ec752-9c2c-447a-9a1c-883ac26830be" alt="Screenshot of the problem" width="25%">

## Using the package

First, you need to add this package to your project dependencies. Then, you can import the package and use the `.keyboardAccessory` modifier on any type of scrolling view.                                     

```swift
import SwiftUI
import KeyboardAccessory // Import the package

struct ContentView: View {
    var body: some View {
        VStack {
            ChatView()
                .keyboardAccessory {
                    InputView() // The view you want to use as an accessory
                }
                .scrollDismissesKeyboard(.interactively) // Dismiss the keyboard interactively
        }
    }
}
```

There is also a `background` closure that lets you add a background view. 

```swift
ScrollView {}
    .keyboardAccessory {
        // Accessory
    } background {
        Rectangle()
            .fill(.regularMaterial)
    }
```

## Credits

This package was built using [BottomInputBarSwiftUI](https://github.com/frogcjn/BottomInputBarSwiftUI), which is used under the MIT license as per the user's permission. I only made some changes to the modifier and created a package. All credit for the actual implementation goes to [frogcjn](https://github.com/frogcjn).




