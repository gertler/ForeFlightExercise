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
    @IBOutlet weak var shouldCacheSwitch: UISwitch!
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Settings"
        
        // Units setup
        if UnitsConversionHandler.shared.units == .imperial {
            unitsSegmentedControl.selectedSegmentIndex = 0
        } else {
            unitsSegmentedControl.selectedSegmentIndex = 1
        }
        
        // Should Convert Setup
        let shouldConvert = UnitsConversionHandler.shared.shouldConvert
        shouldConvertSwitch.isOn = shouldConvert
        toggleShouldConvert(shouldConvert)
        
        // Should Cache Setup
        let shouldCache = SavedAirportsHandler.shared.shouldCache
        shouldCacheSwitch.isOn = shouldCache
        toggleShouldCache(shouldCache)
    }
    
    // MARK: - Helper Functions
    
    private func toggleShouldConvert(_ isOn: Bool) {
        shouldConvertSwitch.isOn = isOn
        UnitsConversionHandler.shared.shouldConvert = isOn
        unitsSegmentedControl.isEnabled = isOn
    }
    
    private func toggleShouldCache(_ isOn: Bool) {
        shouldCacheSwitch.isOn = isOn
        SavedAirportsHandler.shared.shouldCache = isOn
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
        guard let sw = sender as? UISwitch,
              sw == shouldConvertSwitch else {
            return
        }
        toggleShouldConvert(sw.isOn)
    }
    
    @IBAction func shouldCacheSwitched(_ sender: Any) {
        guard let sw = sender as? UISwitch,
              sw == shouldCacheSwitch else {
            return
        }
        toggleShouldCache(sw.isOn)
    }

}
