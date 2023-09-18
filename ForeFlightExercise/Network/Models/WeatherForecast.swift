//
//  WeatherForecast.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/18/23.
//

import Foundation

struct WeatherForecast: Codable {
    let text: String
    let identity: String
    let dateIssued: Date
    let period: ForecastPeriod
    let latitude: Float
    let longitude: Float
    let elevationFt: Float
    // NOTE: Without additional context, I don't know if these conditions are the same as in `WeatherConditions` with the added "period" and no "ident"
    // With it being relatively trivial to copy/paste, I would rather make this "conditions" separate instead of gunking up the other one with Optionals
    // See README.md for even more details on this decision; I went back and forth on reusing versus copy/pasting.
    let conditions: [ForecastConditions]
    
    private enum CodingKeys: String, CodingKey {
        case text
        case identity = "ident"
        case dateIssued
        case period
        case latitude = "lat"
        case longitude = "lon"
        case elevationFt
        case conditions
    }
}

struct ForecastPeriod: Codable {
    let dateStart: Date
    let dateEnd: Date
}

struct ForecastConditions: Codable {
    let text: String
    let dateIssued: Date
    let latitude: Float
    let longitude: Float
    let elevationFt: Float
    let relativeHumidity: Int
    // Perhaps this is an enum, but I don't have enough information to fully cover all cases
    let change: String?
    let flightRules: FlightRules
    let cloudLayers: [CloudLayer]
    let cloudLayersV2: [CloudLayer]
    let weather: [String]
    let visibility: Visibility
    let wind: Wind
    let period: ForecastPeriod
    
    private enum CodingKeys: String, CodingKey {
        case text
        case dateIssued
        case latitude = "lat"
        case longitude = "lon"
        case elevationFt
        case relativeHumidity
        case change
        case flightRules
        case cloudLayers
        case cloudLayersV2
        case weather
        case visibility
        case wind
        case period
    }
}
