# ForeFlight Exercise README
This project was built to demonstrate skills as an iOS developer for ForeFlight.

## Time Spent
I spent around 12 hours developing this app, over the course of 3 days. I began around 1pm 09/18/2023, and wrapped up to a good stopping point around 11am 09/20/2023. With more time though, I think I could greatly improve the Details page with graphics and nice formatting, as well as shift to a more MVVM approach from an MVC one.

## Design Decisions
### Decoding JSON
I made the decision to "roll my own" `Codable` objects instead of finding a library for a few reasons:
1. It is possible that the JSON returned by the API either adds or changes some data in a subtle way that would go undetected by a 3rd party library
1. Customizing my own `Codable` objects helps to show my understanding of basic JSON parsing in Swift
1. This design is likely to be more lightweight and customizable than any 3rd party library

### Data Fetching
My approach to organizing and fetching the data in this project was simple: create a lightweight handler for 1 small HTTP call. Anything more frankly would be over-engineered.

### Data Models
My approach here was fairly standard. Classic Codable objects for a JSON that has no dynamic keys (except for the `windsAloft` object). Given more time, I would have loved to tackle parsing that data too, as I have previously encountered dynamic-key JSON, and it was one of my favorite challenges I've solved using Swift. **Please please please** ask me about that if you are curious.

With regards to using Optionals in some places but not others, I go over this in more detail [here](#other-notes).

### "Primarily" UIKit
This is obviously subject to opinion, but I took this to mean that IB (Interface Builder) was okay to use in small doses. In almost every Xcode project I have seen/written personally, IB was used sparingly. However, in circumstances where it would take a lot of code with programmatic UIKit, IB usually proves its worth. By combining the simplicity of IB's ViewController templates with programmatic UIKit customization, I demonstrated the pros and cons of IB and programmatic UI.

### Details Page
My biggest pitfall during this exercise was building UI for the displayed detail information about the weather reports. I chose to go the simple, yet crude, route, which wound up being functional enough. This choice allowed me to spend a bit more time tweaking other portions of the code, and I think the overall quality would have dipped if I had spent more time fleshing out the details page into something a bit nicer to look at. The one small gimmick I added was a color code to show at a glance what the Flight Rules were. My friend, Morgan, who I referenced for help with aviation terminology, told me that each of the 4 Flight Rules are color-coordinated, so having those be displayed was a nice touch.

### Data Caching
I chose to use `UserDefaults` to cache the airports codes (4 letters), which will persist through launches. On the other hand, caching the full JSON data seemed to be less helpful to a user, since relaunching the app could happen minutes or hours later, so cached data from then would likely be useless (NOTE: I am not a pilot, nor work in aviation, so this assumption on my part could be wrong). So, I determined that caching data per app launch was sufficient, so any data fetched without killing the app will persist and be used in leu of fetching again. In order to make sure users can still override the cache, I added a Setting to disable caching, as well as a background refresh that automatically updates the cache with the latest data from any cached airports.

## References and 3rd Party Libraries
A big thanks to my friend Morgan, who actually taught me how to read **METAR/TAF** during COVID while she was training to be a flight instructor (*and then helped me again because I forgot most of it!*)

I used [weather.gov](https://www.weather.gov/media/wrh/mesowest/metar_decode_key.pdf)'s METAR/TAF reference guide to attempt to cover all my bases when building data models for the API

## Known Issues
### Data Parsing
Currently, the data fetching will fail to parse the entire object if there is a mismatched field anywhere in the JSON; this is normally very bad. However, I am convinced that this exercise is meant to see what would be done in a case where there is no specified documentation to know what all of the fields could be. I discuss this [here](#other-notes), but this issue actually does help highlight the lack of API docs well. Thus, this is done somewhat intentionally, since making every single field Optional feels like skirting around the issue almost the same amount.

### Details View Spacing
As is obvious, I am not a graphical designer. The details view is the simplest version of programmatically adding every parsed field into a `UIScrollView`. With that said, the vertical `UIStackView` that encompasses these `UILabel`s seems to have a quirk with the spacing between labels. Sometimes, the spacing will be tight, but other times, the spacing is thrown off and each field is spaced wide apart. The problem here is that the 2 independent `UIStackView`s for conditions and forecast are fighting to control the height of the superview, so the taller one will win and cause the other to have more spacing between labels. However, given another day, I would have implemented something more robust, like using a `UICollectionView` to display each field in its own cell, rather than crudely showing them in plaintext. This would effectively fix this issue by causing it not to matter.

### Settings Desynced From Airport Page
This is more of a logical error than bug, but when going to the Settings tab to change something like units or caching, the data on the Airports tab will **not** change to reflect this toggled state until you back out of the Details page. The solution here is to rework the View/View Model portion of the code to more directly respond to these changes. Due to how I initially programmed the Details page, once the page loads, no Views can update to reflect a change in the Data Models. Going back to [here](#details-view-spacing), a more dynamic system like `UITableView` or `UICollectionView` would allow for updating Views on the fly when the View Model changes.

## Other Notes
Throughout this project, I encountered a few different hurdles that are worth discussing. First, I tackled the network side of things first, in order to have more confidence when building the subsequent UI that data was being parsed and represented properly. While building the parsing infrastructure, I quickly discovered that the server endpoint had JSON fields that would not always appear inside objects. For instance, weather condition wind data would only show gust speed at certain threshholds. Naturally, `Decodable` objects want to at least see a key, even if the value is null or empty. This is solved with Swift Optionals, but without documentation that has 100% coverage for every possible field that *could* appear, the options were to search for documentation online, abandon `Codable`, or attempt to cobble together 100% coverage by testing unique airports to join their different fields into one usable model. With the first option being inconsistent, and the second being inadvisable, I opted for the third. 

On the subject of Models and Optionals, I believe that an approach that only uses optionals when strictly needed is best, because "gumming"-up code with countless unwraps for API fields that should **always** exist is messy. However, the "safe" approach of using Optionals for every field certainly has its upsides; notably, when the API spec changes a previously required field to an optional one, nothing needs to change on the front-end if it was assumed Optional from the start. For the purposes of this exercise and trying to save time and headaches, I was fastidious with how I selected what was optional in my models. In a real-world scenario and given an API reference, I might have written this with more Optionals.

Now, I would like to discuss the extra add-ons that I included apart from the exercise specs. I added a simple units converter that, when enabled, can change certain values in feet or celcius to meters or fahrenheit. Due to how the JSON is structured, my solution here is somewhat hacky, but nevertheless it can help to see distance and temperatures in more "meaningful" units if imperial or metric system is preferred. I also included a caching system that will store data that was fetched from the server for the duration of the app's life after launching. This system will remove deleted data as well as try to update at intervals to refetch new versions of the data.
