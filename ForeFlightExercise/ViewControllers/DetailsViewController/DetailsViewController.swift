//
//  DetailsViewController.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/18/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var airport: String! {
        didSet {
            Task {
                weatherReport = try await FFAPIController.shared.getWeather(airportID: airport)
                setViews()
            }
        }
    }
    var weatherReport: WeatherReport?
        
    // MARK: - Outlets
        
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - Initialization
    
    static func createDetailsViewController(_ airport: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "DetailsViewController", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController")
        
        // Set the airport
        if let detailVC = vc as? DetailsViewController {
            detailVC.airport = airport
            detailVC.title = airport
        }
        return vc
    }
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setup
    
    private func setViews() {
        guard let report = weatherReport,
              let conditions = report.conditions else {
            // TODO: Add empty state handler
            return
        }
        
        setBgColorByFlightRules(conditions.flightRules)
        
        // METAR/TAF Text
        helpGenerateLabel("Text", value: conditions.text)
        helpGenerateLabel("Date", value: conditions.dateIssued.description)
        helpGenerateLabel("Latitude", value: conditions.latitude)
        helpGenerateLabel("Longitude", value: conditions.longitude)
        helpGenerateLabel("Elevation Ft", value: conditions.elevationFt)
        helpGenerateLabel("TempC", value: conditions.tempC)
        helpGenerateLabel("DewpointC", value: conditions.dewpointC)
        helpGenerateLabel("PressureHg", value: conditions.pressureHg)
        helpGenerateLabel("PressureHpa", value: conditions.pressureHpa)
        helpGenerateLabel("Reported As Hpa", value: conditions.reportedAsHpa)
        helpGenerateLabel("Density Altitude Ft", value: conditions.densityAltitudeFt)
        helpGenerateLabel("Relative Humidity", value: conditions.relativeHumidity)
        helpGenerateLabel("Autonomous", value: conditions.autonomous)
        helpGenerateLabel("Flight Rules", value: conditions.flightRules.rawValue.uppercased())
        helpGenerateLabel("Cloud Layers", value: "")
        helpGenerateLabel(cloudLayers: conditions.cloudLayers)
        if !conditions.weatherPhenomena.isEmpty{
            helpGenerateLabel("Weather", value: conditions.weatherPhenomena.joined(separator: ", "))
        }
        
        // Visibility
        helpGenerateLabel("Visibility", value: "")
        helpGenerateLabel("Distance Sm", value: conditions.visibility.distanceSm, tabbed: true)
        helpGenerateLabel("Distance Qualifier", value: conditions.visibility.distanceQualifier, tabbed: true)
        helpGenerateLabel("Prevailing Vis Sm", value: conditions.visibility.prevailingVisSm, tabbed: true)
        helpGenerateLabel("Prevailing Vis Distance Qualifier", value: conditions.visibility.prevailingVisDistanceQualifier, tabbed: true)
        
        // Wind
        helpGenerateLabel("Wind", value: "")
        helpGenerateLabel("Speed Kts", value: conditions.wind.speedKts, tabbed: true)
        helpGenerateLabel("Gust Speed Kts", value: conditions.wind.gustSpeedKts, tabbed: true)
        helpGenerateLabel("Direction", value: conditions.wind.direction, tabbed: true)
        helpGenerateLabel("Variable From", value: conditions.wind.variableFrom, tabbed: true)
        helpGenerateLabel("Variable To", value: conditions.wind.variableTo, tabbed: true)
        helpGenerateLabel("From", value: conditions.wind.from, tabbed: true)
        helpGenerateLabel("To", value: conditions.wind.to, tabbed: true)
        helpGenerateLabel("Variable", value: conditions.wind.variable, tabbed: true)
        
        // Remarks
        helpGenerateLabel("Remarks", value: "")
        helpGenerateLabel("Precipitation Discriminator", value: conditions.remarks.precipitationDiscriminator, tabbed: true)
        helpGenerateLabel("Human Observer", value: conditions.remarks.humanObserver, tabbed: true)
        helpGenerateLabel("Sea Level Pressure", value: conditions.remarks.seaLevelPressure, tabbed: true)
        helpGenerateLabel("Pressure Tendancy Rate", value: conditions.remarks.pressureTendancyRate, tabbed: true)
        helpGenerateLabel("Pressure Tendancy Characteristics", value: conditions.remarks.pressureTendancyCharacteristics, tabbed: true)
        helpGenerateLabel("Temperature", value: conditions.remarks.temperature, tabbed: true)
        helpGenerateLabel("Dewpoint", value: conditions.remarks.dewpoint, tabbed: true)
//        helpGenerateLabel("Visibility", value: conditions.remarks.visibility, tabbed: true)
        for status in conditions.remarks.sensoryStatus {
            helpGenerateLabel("Sensory Status", value: status.sensorStatusCode, tabbed: true)
        }
        helpGenerateLabel("Lightning", value: conditions.remarks.lightning.joined(separator: " "), tabbed: true)
//        helpGenerateLabel("Weather Begin Ends", value: conditions.remarks.weatherBeginEnds, tabbed: true)
        helpGenerateLabel("Clouds", value: conditions.remarks.clouds.joined(separator: " "), tabbed: true)
        helpGenerateLabel("Obscuring Layers", value: conditions.remarks.obscuringLayers.joined(separator: " "), tabbed: true)
        helpGenerateLabel("Maintenance Needed", value: conditions.remarks.maintenanceNeeded, tabbed: true)
    }
    
    // My friend Morgan (a pilot) told me that Flight Rules have associated colors
    // So, setting the background to a slight tint could help with readability at a quick glance
    private func setBgColorByFlightRules(_ flightRules: FlightRules) {
        switch flightRules {
        case .MVFR:
            stackView.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        case .VFR:
            stackView.backgroundColor = .systemGreen.withAlphaComponent(0.3)
        case .IFR:
            stackView.backgroundColor = .systemRed.withAlphaComponent(0.3)
        case .LIFR:
            stackView.backgroundColor = .systemPink.withAlphaComponent(0.3)
        }
    }
    
    // MARK: - Helper Functions
    
    private func helpGenerateLabel(_ key: String, value: String?, tabbed: Bool = false) {
        guard let _value = value else { return }
        
        let label = UILabel()
        label.text = "\(tabbed ? "\t" : "")\(key): \(_value)"
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        stackView.addArrangedSubview(label)
    }
    
    private func helpGenerateLabel(_ key: String, value: Float?, tabbed: Bool = false) {
        guard let _value = value else { return }
        helpGenerateLabel(key, value: "\(_value)", tabbed: tabbed)
    }
    
    private func helpGenerateLabel(_ key: String, value: Int?, tabbed: Bool = false) {
        guard let _value = value else { return }
        helpGenerateLabel(key, value: "\(_value)", tabbed: tabbed)
    }
    
    private func helpGenerateLabel(_ key: String, value: Bool?, tabbed: Bool = false) {
        guard let _value = value else { return }
        helpGenerateLabel(key, value: "\(_value)".capitalized, tabbed: tabbed)
    }
    
    private func helpGenerateLabel(cloudLayers layers: [CloudLayer]) {
        for layer in layers {
            let label = UILabel()
            label.text = "\t\(layer.coverage.rawValue) at \(layer.altitudeFt); ceiling: \(layer.ceiling)"
            label.lineBreakMode = .byCharWrapping
            label.numberOfLines = 0
            label.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
            stackView.addArrangedSubview(label)
        }
    }

}
