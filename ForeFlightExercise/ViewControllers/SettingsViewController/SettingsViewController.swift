//
//  SettingsViewController.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/19/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var shouldConvertSwitch: UISwitch!
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Settings"
        
        if UnitsConversionHandler.shared.units == .imperial {
            unitsSegmentedControl.selectedSegmentIndex = 0
        } else {
            unitsSegmentedControl.selectedSegmentIndex = 1
        }
        
        let shouldConvert = UnitsConversionHandler.shared.shouldConvert
        shouldConvertSwitch.isOn = shouldConvert
        toggleShouldConvert(shouldConvert)
    }
    
    // MARK: - Helper Functions
    
    private func toggleShouldConvert(_ isOn: Bool) {
        shouldConvertSwitch.isOn = isOn
        UnitsConversionHandler.shared.shouldConvert = isOn
        unitsSegmentedControl.isEnabled = isOn
    }
    
    // MARK: - IBActions
    
    @IBAction func unitsChanged(_ sender: Any) {
        guard let segControl = sender as? UISegmentedControl else {
            return
        }
        
        if segControl.selectedSegmentIndex == 0 {
            UnitsConversionHandler.shared.units = .imperial
        } else {
            UnitsConversionHandler.shared.units = .metric
        }
    }
    
    @IBAction func shouldConvertSwitched(_ sender: Any) {
        guard let sw = sender as? UISwitch else {
            return
        }
        toggleShouldConvert(sw.isOn)
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
