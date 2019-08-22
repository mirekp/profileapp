# ProfileApp

## What is this?

This repo is meant to be a result of a coding task. It demonstrates a simple one-view app that fetches a JSON file from the network and presents it in a simple UITableView layout.

## How to run this

* The project file should open & compile & run in Xcode 10.3. 
* It should run in other versions of Xcode too. I needs Swift 4+ due to the use of `Decodable` protocol used to parse JSON.

## Implementation notes

* As I wanted to timebox the solution I took a minimalistic aproach with a very basic feature set and simple UI. It is not meant to be submmitted to the AppStore :).
* The code is structured using a variation of a Clean Swift architecture where presentation logic is separated from business logic and service layer.
* The code is fully covered by behavioral-style unit tested and has been developed using TDD principles.
* "Happy path" is covered by an integration UI test (using XCUITest)
* As there was a requirement to not use any exterenal libraries, the UI test use a very simple test injection hook. Should there was no such requirement a fully integrated test web server (such as https://github.com/swisspol/GCDWebServer or https://github.com/square/okhttp/tree/master/mockwebserver) would have been used for full networking dependency injection.
* The JSON data file used by the app is hardcoded in the service layer and is pointing to this file - https://gist.githubusercontent.com/mirekp/afb5bf6c4b843dae279845bf85036a26/raw
