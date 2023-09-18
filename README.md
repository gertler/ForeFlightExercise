# ForeFlight Exercise README
This project was built to demonstrate skills as an iOS developer for ForeFlight.

## Design Decisions
### Decoding JSON
I made the decision to "roll my own" `Codable` objects instead of finding a library for a few reasons:
1. It is possible that the JSON returned by the API either adds or changes some data in a subtle way that would go undetected by a 3rd party library
1. Customizing my own `Codable` objects helps to show my understanding of basic JSON parsing in Swift
1. This design is likely to be more lightweight and customizable than any 3rd party library

## References and 3rd Party Libraries
A big thanks to my friend Morgan, who actually taught me how to read **METAR/TAF** during COVID while she was training to be a flight instructor (*and then helped me again because I forgot most of it!*)
I used [weather.gov](https://www.weather.gov/media/wrh/mesowest/metar_decode_key.pdf)'s METAR/TAF reference guide to attempt to cover all my bases

## Known Issues

## Other Notes
Throughout this project, I encountered a few different hurdles that are worth discussing. First, I tackled the network side of things first, in order to have more confidence when building the subsequent UI that data was being parsed and represented properly. While building the parsing infrastructure, I quickly discovered that the server endpoint had JSON fields that would not always appear inside objects. For instance, weather condition wind data would only show gust speed at certain threshholds. Naturally, `Decodable` objects want to at least see a key, even if the value is null or empty. This is solved with Swift Optionals, but without documentation that has 100% coverage for every possible field that *could* appear, the options were to search for documentation online, abandon `Codable`, or attempt to cobble together 100% coverage by testing unique airports to join their different fields into one usable model. With the first option being inconsistent, and the second being inadvisable, I opted for the third. 
