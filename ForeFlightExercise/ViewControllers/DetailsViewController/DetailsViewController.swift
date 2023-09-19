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
                setupViews()
            }
        }
    }
    var weatherReport: WeatherReport?
        
    // MARK: - Outlets
    
    @IBOutlet weak var mainView: UIView!
    
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
    
    private func setupViews() {
        guard let report = weatherReport,
              let conditions = report.conditions else {
            // TODO: Add empty state handler
            return
        }
        
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
        helpGenerateLabel("Flight Rules", value: conditions.flightRules.rawValue.uppercased())
    }
    
    // MARK: - Helper Functions
    
    private func helpGenerateLabel(_ key: String, value: String) {
        let label = UILabel()
        label.text = "\(key): \(value)"
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        stackView.addArrangedSubview(label)
    }
    
    private func helpGenerateLabel(_ key: String, value: Float) {
        helpGenerateLabel(key, value: "\(value)")
    }
    
    private func helpGenerateLabel(_ key: String, value: Int) {
        helpGenerateLabel(key, value: "\(value)")
    }
    
    private func helpGenerateLabel(_ key: String, value: Bool) {
        helpGenerateLabel(key, value: "\(value)".capitalized)
    }

}
