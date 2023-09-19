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
                setConditionsViews()
                setForecastViews()
            }
        }
    }
    var weatherReport: WeatherReport?
        
    // MARK: - Outlets
        
    @IBOutlet weak var conditionsStackView: UIStackView!
    @IBOutlet weak var forecastStackView: UIStackView!
    @IBOutlet weak var detailSegmentedControl: UISegmentedControl!
    
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
        conditionsStackView.isHidden = false
        forecastStackView.isHidden = true
        detailSegmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - Setup
    
    private func setConditionsViews() {
        guard let report = weatherReport,
              let conditions = report.conditions else {
            // TODO: Add empty state handler
            return
        }
        
        setBgColorByFlightRules(conditions.flightRules, for: conditionsStackView)
        
        // METAR/TAF Text
        helpGenerateLabel(for: conditionsStackView, "Text", value: conditions.text)
        helpGenerateLabel(for: conditionsStackView, "Date", value: conditions.dateIssued.formatted())
        helpGenerateLabel(for: conditionsStackView, "Latitude", value: conditions.latitude)
        helpGenerateLabel(for: conditionsStackView, "Longitude", value: conditions.longitude)
        helpGenerateLabel(for: conditionsStackView, "Elevation Ft", value: conditions.elevationFt)
        helpGenerateLabel(for: conditionsStackView, "TempC", value: conditions.tempC)
        helpGenerateLabel(for: conditionsStackView, "DewpointC", value: conditions.dewpointC)
        helpGenerateLabel(for: conditionsStackView, "PressureHg", value: conditions.pressureHg)
        helpGenerateLabel(for: conditionsStackView, "PressureHpa", value: conditions.pressureHpa)
        helpGenerateLabel(for: conditionsStackView, "Reported As Hpa", value: conditions.reportedAsHpa)
        helpGenerateLabel(for: conditionsStackView, "Density Altitude Ft", value: conditions.densityAltitudeFt)
        helpGenerateLabel(for: conditionsStackView, "Relative Humidity", value: conditions.relativeHumidity)
        helpGenerateLabel(for: conditionsStackView, "Autonomous", value: conditions.autonomous)
        helpGenerateLabel(for: conditionsStackView, "Flight Rules", value: conditions.flightRules.rawValue.uppercased())
        helpGenerateLabel(for: conditionsStackView, "Cloud Layers", value: "")
        helpGenerateLabel(for: conditionsStackView, cloudLayers: conditions.cloudLayers)
        if !conditions.weatherPhenomena.isEmpty{
            helpGenerateLabel(for: conditionsStackView, "Weather", value: conditions.weatherPhenomena.joined(separator: ", "))
        }
        
        // Visibility
        helpGenerateLabel(for: conditionsStackView, "Visibility", value: "")
        helpGenerateLabel(for: conditionsStackView, "Distance Sm", value: conditions.visibility.distanceSm, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Distance Qualifier", value: conditions.visibility.distanceQualifier, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Prevailing Vis Sm", value: conditions.visibility.prevailingVisSm, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Prevailing Vis Distance Qualifier", value: conditions.visibility.prevailingVisDistanceQualifier, tabbed: true)
        
        // Wind
        helpGenerateLabel(for: conditionsStackView, "Wind", value: "")
        helpGenerateLabel(for: conditionsStackView, "Speed Kts", value: conditions.wind.speedKts, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Gust Speed Kts", value: conditions.wind.gustSpeedKts, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Direction", value: conditions.wind.direction, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Variable From", value: conditions.wind.variableFrom, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Variable To", value: conditions.wind.variableTo, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "From", value: conditions.wind.from, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "To", value: conditions.wind.to, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Variable", value: conditions.wind.variable, tabbed: true)
        
        // Remarks
        helpGenerateLabel(for: conditionsStackView, "Remarks", value: "")
        helpGenerateLabel(for: conditionsStackView, "Precipitation Discriminator", value: conditions.remarks.precipitationDiscriminator, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Human Observer", value: conditions.remarks.humanObserver, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Wind From", value: conditions.remarks.windFrom, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Wind Speed", value: conditions.remarks.windSpeed, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Wind Date", value: conditions.remarks.windDate?.formatted(), tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Sea Level Pressure", value: conditions.remarks.seaLevelPressure, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Pressure Tendancy Rate", value: conditions.remarks.pressureTendancyRate, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Pressure Tendancy Characteristics", value: conditions.remarks.pressureTendancyCharacteristics, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Temperature", value: conditions.remarks.temperature, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Dewpoint", value: conditions.remarks.dewpoint, tabbed: true)
//        helpGenerateLabel(for: conditionsStackView, "Visibility", value: conditions.remarks.visibility, tabbed: true)
        for status in conditions.remarks.sensoryStatus {
            helpGenerateLabel(for: conditionsStackView, "Sensory Status", value: status.sensorStatusCode, tabbed: true)
        }
        helpGenerateLabel(for: conditionsStackView, "Lightning", value: conditions.remarks.lightning.joined(separator: " "), tabbed: true)
//        helpGenerateLabel(for: conditionsStackView, "Weather Begin Ends", value: conditions.remarks.weatherBeginEnds, tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Clouds", value: conditions.remarks.clouds.joined(separator: " "), tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Obscuring Layers", value: conditions.remarks.obscuringLayers.joined(separator: " "), tabbed: true)
        helpGenerateLabel(for: conditionsStackView, "Maintenance Needed", value: conditions.remarks.maintenanceNeeded, tabbed: true)
    }
    
    private func setForecastViews() {
        guard let report = weatherReport,
              let forecast = report.forecast else {
            // TODO: Add empty state handler
            return
        }
                
        helpGenerateLabel(for: forecastStackView, "Text", value: forecast.text)
        helpGenerateLabel(for: forecastStackView, "Date", value: forecast.dateIssued.formatted())
        helpGenerateLabel(for: forecastStackView, "Period", value: "")
        helpGenerateLabel(for: forecastStackView, "Start Date", value: forecast.period.dateStart.formatted(), tabbed: true)
        helpGenerateLabel(for: forecastStackView, "End Date", value: forecast.period.dateEnd.formatted(), tabbed: true)
        helpGenerateLabel(for: forecastStackView, "Latitude", value: forecast.latitude)
        helpGenerateLabel(for: forecastStackView, "Longitude", value: forecast.longitude)
        helpGenerateLabel(for: forecastStackView, "Elevation Ft", value: forecast.elevationFt)
        
        // Conditions
        for condition in forecast.conditions {
            helpGenerateLabel(for: forecastStackView, "Text", value: condition.text)
            helpGenerateLabel(for: forecastStackView, "Date", value: condition.dateIssued.formatted())
            helpGenerateLabel(for: forecastStackView, "Latitude", value: condition.latitude)
            helpGenerateLabel(for: forecastStackView, "Longitude", value: condition.longitude)
            
        }
    }
    
    // My friend Morgan (she's a pilot) told me that Flight Rules have associated colors
    // So, setting the background to a slight tint could help with readability at a quick glance
    private func setBgColorByFlightRules(_ flightRules: FlightRules, for stackView: UIStackView) {
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
    
    private func helpGenerateLabel(for stackView: UIStackView, _ key: String, value: String?, tabbed: Bool = false) {
        guard let _value = value else { return }
        
        let label = UILabel()
        label.text = "\(tabbed ? "\t" : "")\(key): \(_value)"
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        stackView.addArrangedSubview(label)
    }
    
    private func helpGenerateLabel(for stackView: UIStackView, _ key: String, value: Float?, tabbed: Bool = false) {
        guard let _value = value else { return }
        helpGenerateLabel(for: stackView, key, value: "\(_value)", tabbed: tabbed)
    }
    
    private func helpGenerateLabel(for stackView: UIStackView, _ key: String, value: Int?, tabbed: Bool = false) {
        guard let _value = value else { return }
        helpGenerateLabel(for: stackView, key, value: "\(_value)", tabbed: tabbed)
    }
    
    private func helpGenerateLabel(for stackView: UIStackView, _ key: String, value: Bool?, tabbed: Bool = false) {
        guard let _value = value else { return }
        helpGenerateLabel(for: stackView, key, value: "\(_value)".capitalized, tabbed: tabbed)
    }
    
    private func helpGenerateLabel(for stackView: UIStackView, cloudLayers layers: [CloudLayer]) {
        for layer in layers {
            let label = UILabel()
            label.text = "\t\(layer.coverage.rawValue) at \(layer.altitudeFt); ceiling: \(layer.ceiling)"
            label.lineBreakMode = .byCharWrapping
            label.numberOfLines = 0
            label.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
            stackView.addArrangedSubview(label)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func detailSegmentedControlValueChanged(_ sender: Any) {
        guard let segControl = sender as? UISegmentedControl else {
            return
        }
        
        if segControl.selectedSegmentIndex == 0 {
            conditionsStackView.isHidden = false
            forecastStackView.isHidden = true
        } else {
            conditionsStackView.isHidden = true
            forecastStackView.isHidden = false
        }
    }
    

}
