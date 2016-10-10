##SNSSocial

###2.0.1

Updates FBSDK & STTwitter dependencies

Ensures compatibility with iOS 10

###2.0

First public version

- Code reviews and some methods renamed
- Migrates to "cocoapods library" project
- Updates sample app

###1.3

Improves Swift Usability, XCode 7.3 ready, Twitter improvements, minor fixes

- Adds SNSSocial Swift Sample application and improves Objective-C Sample application
- Specifies nullability informations (to improves Swift compatibility)
- Fixes compatibility issue between SNSFacebook and XCode 7.3
- Reworks the SNSTwitter login process in order to allow to restore previous connection if the app is killed
- Improves upload of pictures with tweets (according twitter API evolutions) and fixes upload of pictures to facebook

###1.2

Updates Facebook and Twitter SDKs, improves compatibility with iOS 9 and fixes compatibility with Swift

- Updates Facebook login methods
- Updates Facebook getUserInformations method (defines a lot of new user informations constants)
- Updates Sample App

###1.1

Adds new features for facebook and twitter use :
- Sharing picture with tweet or publish photo on facebook without dialog
- Getting facebook user informations (email, name, profile picture etc.)
- Getting twitter username or profile picture

###1.0

First library version