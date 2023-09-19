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
        guard let report = weatherReport else {
            // TODO: Add empty state handler
            return
        }
        
        let textLabel = UILabel()
        textLabel.text = report.conditions?.text
        textLabel.lineBreakMode = .byCharWrapping
        textLabel.numberOfLines = 0
        textLabel.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        stackView.addArrangedSubview(textLabel)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
