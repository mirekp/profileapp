# ProfileApp

## What is this?

This repository contains an outcome of a coding task. It demonstrates a simple one-view app that fetches a GitHub hosted JSON file from the network and presents it in a simple UITableView layout.

## What it is not?

* The project is only designed to demonstrate coding techniques. Such as TDD, JSON parsing, error handling, presentation design patterns, responsibility separation.
* It is not meant to be a complete meaningful app that is to be submmitted to the AppStore. At least not without designing App icon and other polishing tasks first 😊

## How to run?

* The project file should open & compile & run in the Xcode 10.3 which is the latest production version available. Sorry about not using Xcode 10.1 due to practical reasons.
* What limits the support for older versions of Xcode (or  Swift compiler) is most liely my use of the new `Result` type and `Decodable` protocol. I think these are justified as they make the JSON and error handling implementation elegant and I really wanted to demonstrate that in this task. Let's hope this will be considered as a nice implementation detail and not breach of any requirements 😊

## Implementation Notes

* As I wanted to timebox the solution I took a minimalistic aproach with a very basic feature set and simple UI to satisfy the requirement.
* The code is structured using a simplified variation of the [Clean Swift](https://clean-swift.com) architecture where presentation logic is separated from business logic (interactior) and service layer.
* The code is fully covered by behavioral-style unit tests and has been developed using TDD principles.
* The app is also covered by an integration UI test which I used to drive the implementation.
* As there was a requirement to not use any exterenal libraries, the UI test use a very simple test injection hook in the app. Should there was no such requirement a fully integrated test web server (such as https://github.com/swisspol/GCDWebServer or https://github.com/square/okhttp/tree/master/mockwebserver) would have been used for full networking dependency injection in UI tests.
* The JSON data file used by the app is currently hardcoded in the service code and is pointing to this file - https://gist.githubusercontent.com/mirekp/afb5bf6c4b843dae279845bf85036a26/raw.  
* Due to the very simple UI layout used I couldn't find any place where using of programmatically created autolayout would be apropriate (if that's what's meant by " Use autolayout in code"). Be assured I know how to use autolayout (both visual format language as welll as `NSLayoutConstraint`) when needed.
