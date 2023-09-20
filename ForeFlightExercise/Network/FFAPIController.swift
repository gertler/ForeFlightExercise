//
//  FFAPIController.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/18/23.
//

import Foundation

class FFAPIController {
    
    /// Singleton object for accessing ForeFlight API
    static let shared = FFAPIController.init()
    
    var refreshTimer: Timer!
    var refreshSeconds = Double(60)
    
    private static let endpoint = "https://qa.foreflight.com/weather/report"
    
    // MARK: - Init
    
    init() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshSeconds, repeats: true) { _ in
            guard SavedAirportsHandler.shared.shouldCache else {
                return
            }
            
            Task {
                await self.helpRefreshCache()
            }
        }
    }
        
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
        
        addToCache(weatherData.report)
        return weatherData.report
    }
    
    private func addToCache(_ report: WeatherReport) {
        guard SavedAirportsHandler.shared.shouldCache else {
            return
        }
        
        SavedAirportsHandler.shared.cachedModels.append(report)
    }
    
    private func helpRefreshCache() async {
        try? await withThrowingTaskGroup(of: WeatherReport.self) { group in
            for model in SavedAirportsHandler.shared.cachedModels {
                guard let airport = model.conditions?.identity else {
                    continue
                }
                
                group.addTask {
                    let report = try await self.getWeather(airportID: airport)
                    return report
                }
            }
            
            var newCache: [WeatherReport] = []
            for try await weatherReport in group {
                newCache.append(weatherReport)
            }
            SavedAirportsHandler.shared.cachedModels = newCache
        }
    }
    
}

enum FFAPIError: Error {
    case urlConstructionError
}
