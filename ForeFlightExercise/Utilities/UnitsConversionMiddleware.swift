//
//  UnitsConversionMiddleware.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/19/23.
//

import Foundation

class UnitsConversionMiddleware {
    
    static let shared = UnitsConversionMiddleware()
    
    func convert(key: String, value: String) -> (String, Any) {
        guard let v = Double(value) else {
            return (key, value)
        }
        
        guard UnitsConversionHandler.shared.shouldConvert else {
            return (key, value)
        }
        
        switch key {
        case UnitsFields.elevationFt.rawValue:
            let feet = Measurement(value: v, unit: UnitLength.feet)
            if UnitsConversionHandler.shared.units == .metric {
                return ("Elevation M", feet.converted(to: UnitLength.meters).value)
            }
            
        case UnitsFields.densityAltitudeFt.rawValue:
            let feet = Measurement(value: v, unit: UnitLength.feet)
            if UnitsConversionHandler.shared.units == .metric {
                return ("Density Altitude M", feet.converted(to: UnitLength.meters).value)
            }
            
        case UnitsFields.tempC.rawValue:
            let celcius = Measurement(value: v, unit: UnitTemperature.celsius)
            if UnitsConversionHandler.shared.units == .imperial {
                return ("Temp F", celcius.converted(to: UnitTemperature.fahrenheit).value)
            }
            
        case UnitsFields.dewpointC.rawValue:
            let celcius = Measurement(value: v, unit: UnitTemperature.celsius)
            if UnitsConversionHandler.shared.units == .imperial {
                return ("Dewpoint F", celcius.converted(to: UnitTemperature.fahrenheit).value)
            }
            
        default:
            break
        }
        return (key, value)
    }
}

enum UnitsFields: String {
    case elevationFt = "Elevation Ft"
    case tempC = "Temp C"
    case dewpointC = "Dewpoint C"
    case densityAltitudeFt = "Density Altitude Ft"
}
