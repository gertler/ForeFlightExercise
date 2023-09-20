//
//  UserDefaults+UnitsConversion.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/19/23.
//

import Foundation

class UnitsConversionHandler {
    
    enum UDKeys: String {
        case units
        case shouldConvert
    }
    
    static let shared = UnitsConversionHandler()
    
    var units: FFUnits {
        get {
            // Force unwrap is okay since we always initialize value first in `init()`
            let string = UserDefaults.standard.value(forKey: UDKeys.units.rawValue) as! String
            return FFUnits(rawValue: string)!
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: UDKeys.units.rawValue)
        }
    }
    
    var shouldConvert: Bool {
        get {
            UserDefaults.standard.bool(forKey: UDKeys.shouldConvert.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UDKeys.shouldConvert.rawValue)
        }
    }
    
    // MARK: - Init
    
    init() {
        units = .imperial
    }
}

enum FFUnits: String {
    case imperial
    case metric
}
