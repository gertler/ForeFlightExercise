//
//  FFAPIController.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/18/23.
//

import Foundation

class FFAPIController {
    
    /// Singleton object for accessing ForeFlight API
    static let shared = FFAPIController()
    
    private static let endpoint = "https://qa.foreflight.com/weather/report"
    
    func getWeather(airportID: String) async throws -> WeatherReport {
        guard let url = URL(string: "\(FFAPIController.endpoint)/\(airportID)") else {
            throw FFAPIError.urlConstructionError
        }
        
        // Fetch data from server endpoint
        var request = URLRequest(url: url)
        request.addValue("1", forHTTPHeaderField: "ff-coding-exercise")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode data into model
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let weatherData = try decoder.decode(WeatherData.self, from: data)
        
        return weatherData.report
    }
    
}

enum FFAPIError: Error {
    case urlConstructionError
}
