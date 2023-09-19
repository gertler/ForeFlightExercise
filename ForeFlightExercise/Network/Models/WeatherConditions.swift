//
//  WeatherConditions.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/18/23.
//

import Foundation


struct WeatherConditions: Codable {
    let text: String
    let identity: String
    let dateIssued: Date
    let latitude: Float
    let longitude: Float
    let elevationFt: Float
    let tempC: Float
    let dewpointC: Float
    let pressureHg: Float
    let pressureHpa: Float
    let reportedAsHpa: Bool
    let densityAltitudeFt: Int
    let relativeHumidity: Int
    let autonomous: Bool?
    let flightRules: FlightRules
    let cloudLayers: [CloudLayer]
    let cloudLayersV2: [CloudLayer]
    // NOTE: There seems to be a fixed set of weather phenomena
    // However, I cannot find a consistent set of ALL of them to create an enum to capture every unique one
    let weatherPhenomena: [String]
    let visibility: Visibility
    let wind: Wind
    let remarks: Remarks
    
    private enum CodingKeys: String, CodingKey {
        case text
        case identity = "ident"
        case dateIssued
        case latitude = "lat"
        case longitude = "lon"
        case elevationFt
        case tempC
        case dewpointC
        case pressureHg
        case pressureHpa
        case reportedAsHpa
        case densityAltitudeFt
        case relativeHumidity
        case autonomous
        case flightRules
        case cloudLayers
        case cloudLayersV2
        case weatherPhenomena = "weather"
        case visibility
        case wind
        case remarks
    }
}


// Types of Flight Rules
enum FlightRules: String, Codable {
    case MVFR = "mvfr" // blue
    case VFR = "vfr" // green
    case IFR = "ifr" // red
    case LIFR = "lifr" // pink
}

struct CloudLayer: Codable {
    let coverage: CloudCoverage
    let altitudeFt: Float
    let ceiling: Bool
    let altitudeQualifier: Int?
}

enum CloudCoverage: String, Codable {
    case clear = "clr"
    case skyClear = "skc"
    case few
    case scattered = "sct"
    case broken = "bkn"
    case overcast = "ovc"
    case verticalVisibility = "vv"
}

struct Visibility: Codable {
    let distanceSm: Float?
    let distanceQualifier: Int?
    let prevailingVisSm: Float?
    let prevailingVisDistanceQualifier: Int?
}

struct Wind: Codable {
    let speedKts: Float
    let gustSpeedKts: Float?
    let direction: Int?
    let variableFrom: Int?
    let variableTo: Int?
    let from: Int?
    let to: Int?
    let variable: Bool
}

struct Remarks: Codable {
    let precipitationDiscriminator: Bool
    let humanObserver: Bool
    let windFrom: Int?
    let windSpeed: Int?
    let windDate: Date?
    let seaLevelPressure: Float?
    let sixHourMinimumTemperature: Float?
    let pressureTendancyRate: Float?
    let pressureTendancyCharacteristics: String?
    let temperature: Float?
    let dewpoint: Float?
    let visibility: Visibility
    let sensoryStatus: [SensoryStatus]
    let lightning: [String]
    let weatherBeginEnds: WeatherBeginEnds
    let clouds: [String]
    let obscuringLayers: [String]
    let maintenanceNeeded: Bool?
}

struct SensoryStatus: Codable {
    let sensorStatusCode: String
}

struct WeatherBeginEnds: Codable {}
