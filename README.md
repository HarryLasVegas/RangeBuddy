<img src="Media/RangeBuddyAppIcon.png" width="100" height="100">

# RangeBuddy
![iOS](https://img.shields.io/badge/iOS-26%2B-blue?logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-6.4-orange?logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-27%2B-blue?logo=xcode&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-blue)
![App Intents](https://img.shields.io/badge/App_Intents-Siri-black)
![WidgetKit](https://img.shields.io/badge/WidgetKit-CarPlay-30B0C7)
![Swift Testing](https://img.shields.io/badge/Swift_Testing-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

<a href="https://apple.co/4x2r1FZ"><img src="Media/appstore_black.svg" alt="Download on the App Store" height="50"></a>

*Tired of your EV guessing your range wrong?*  
*Let RangeBuddy work it out from your real consumption - and just ask Siri while you drive.*

RangeBuddy estimates how far your electric car can still go. Enter your **state of charge**, **average consumption**, and **battery capacity** - it does the math and shows your remaining range in kilometers or miles.

| | | |
|---|---|---|
| <img src="Media/1en.png" width="200"> | <img src="Media/2en.png" width="200"> | <img src="Media/3en.png" width="200"> |
| <img src="Media/4en.png" width="200"> | <img src="Media/5en.png" width="200"> | <img src="Media/6en.png" width="200"> |

### Features
+ Siri / hands-free (control it entirely by voice while driving)
+ Live range that updates as you adjust the inputs
+ Widgets for CarPlay and the Home Screen
+ Miles & kilometers + multiple consumption units (kWh/100km, mi/kWh, Wh/mi)
+ Localized: English & German

### Using Siri
+ "Hey Siri, RangeBuddy set SoC"
+ "Hey Siri, RangeBuddy set consumption"
+ "Hey Siri, RangeBuddy set SoC and consumption"
+ "Hey Siri, RangeBuddy get range"


### Please note
+ RangeBuddy can't access your car's data (like the current charge). You enter all values yourself.  
+ Siri only accepts whole numbers for now (iOS 26 and 27).
+ Siri reserves words like 'battery' for your iPhone's own battery - say 'SoC' or 'state of charge' instead.


### Build & Run
1. Clone the repo
2. Open `RangeBuddy.xcodeproj`
3. Build & run the `RangeBuddy` scheme on an iOS 26 or iOS 27 simulator or device

*Siri commands work best on a real device.*


### License
RangeBuddy is released under the MIT License. See [LICENSE](LICENSE) for details.


### Get RangeBuddy
<img src="Media/qr-code.png" width="200">