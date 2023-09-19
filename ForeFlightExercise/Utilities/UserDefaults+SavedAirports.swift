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
    
    var firstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: UDKeys.firstLaunch.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UDKeys.firstLaunch.rawValue)
        }
    }
}
