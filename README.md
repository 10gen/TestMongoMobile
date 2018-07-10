# TestMongoMobile
A sample todo list application demonstrating MongoMobile for iOS

## Getting Started with Swift and iOS
1. Install cocoapods: `sudo gem install cocoapods`
1. Checkout the repo: `git clone git@github.com:10gen/TestMongoMobile.git`
1. Install MongoDB Mobile: `cd TestMongoMobile && pod install`
1. Open the workspace: `open TestMongoMobile.xcworkspace`

## Set up iOS device
1. Connect iOS device via USB cable
1. Enable the Developer app on the iOS device
	* Settings/General/Device Management: Select the Developer app and Trus

## Build and run TestMongoMobile
1. Modify Xcode
	1. Add Apple ID from Xcode/Preferences/Accounts
		* ID: `<your Apple ID>`
		* Manage certificates: Add iOS Development Certifcate
	1. Set Development Team for TestMongoMobile
		* Build Settings/Signing/Development Team: `<Your Team>`
	1. Set iOS Development target, i.e., 11.4
		* Info/Deployment Target
	1. Disable Bit Code for all projects (TestMongoMobile & Pods)
		* Build Settings/Build Options/Enable Bitcode: No
	1. Build and run it: `COMMAND-r`
