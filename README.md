# ForeFlight Exercise README
This project was built to demonstrate skills as an iOS developer for ForeFlight.

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

## References and 3rd Party Libraries
A big thanks to my friend Morgan, who actually taught me how to read **METAR/TAF** during COVID while she was training to be a flight instructor (*and then helped me again because I forgot most of it!*)
I used [weather.gov](https://www.weather.gov/media/wrh/mesowest/metar_decode_key.pdf)'s METAR/TAF reference guide to attempt to cover all my bases when building data models for the API

## Known Issues

## Other Notes
Throughout this project, I encountered a few different hurdles that are worth discussing. First, I tackled the network side of things first, in order to have more confidence when building the subsequent UI that data was being parsed and represented properly. While building the parsing infrastructure, I quickly discovered that the server endpoint had JSON fields that would not always appear inside objects. For instance, weather condition wind data would only show gust speed at certain threshholds. Naturally, `Decodable` objects want to at least see a key, even if the value is null or empty. This is solved with Swift Optionals, but without documentation that has 100% coverage for every possible field that *could* appear, the options were to search for documentation online, abandon `Codable`, or attempt to cobble together 100% coverage by testing unique airports to join their different fields into one usable model. With the first option being inconsistent, and the second being inadvisable, I opted for the third. 

On the subject of Models and Optionals, I believe that an approach that only uses optionals when strictly needed is best, because "gumming"-up code with countless unwraps for API fields that should **always** exist is messy. However, the "safe" approach of using Optionals for every field certainly has its upsides; notably, when the API spec changes a previously required field to an optional one, nothing needs to change on the front-end if it was assumed Optional from the start. For the purposes of this exercise and trying to save time and headaches, I was fastidious with how I selected what was optional in my models. In a real-world scenario and given an API reference, I might have written this with more Optionals.
