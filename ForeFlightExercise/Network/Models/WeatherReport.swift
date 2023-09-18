//
//  WeatherReport.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/18/23.
//

import Foundation

struct WeatherData: Codable {
    let report: WeatherReport
}

struct WeatherReport: Codable {
    let conditions: WeatherConditions?
    let forecast: WeatherForecast?
    let windsAloft: WeatherWindsAloft?
    // I believe this is: Model Output Statistics
    let mos: WeatherMOS?
}

struct WeatherWindsAloft: Codable {}
struct WeatherMOS: Codable {}
