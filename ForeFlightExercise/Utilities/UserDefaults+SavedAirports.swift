//
//  UserDefaults+SavedAirports.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/19/23.
//

import Foundation

class SavedAirportsHandler {
    
    enum UDKeys: String {
        case savedAirports
        case firstLaunch
        case cachedModels
        case shouldCache
    }
    
    static let shared = SavedAirportsHandler()
    
    var saved: [String]? {
        get {
            UserDefaults.standard.array(forKey: UDKeys.savedAirports.rawValue) as? [String]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UDKeys.savedAirports.rawValue)
        }
    }
    
    // Cache resets after each app launch
    // NOTE: This could be changed, but this is specifically chosen to make sure stale data isn't cached
    var cachedModels: [WeatherReport] = []
    
    var shouldCache: Bool {
        get {
            UserDefaults.standard.bool(forKey: UDKeys.shouldCache.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UDKeys.shouldCache.rawValue)
        }
    }
    
    var firstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: UDKeys.firstLaunch.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UDKeys.firstLaunch.rawValue)
        }
    }
}
