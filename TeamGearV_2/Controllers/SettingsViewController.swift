//
//  SettingsViewController.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 4/3/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {
    
    var isSettingsOn:Bool?
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var settingsControlOutlet: UISwitch!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsControlOutlet.isOn = getSettingsIsOnStatus()

        
        
        
        
    }
    
    @IBAction func settingsControllerAction(_ sender: UISwitch) {
        setUserDefaults(switchVal: sender.isOn)
    }
    
   

}


// MARK:- Setup UserDefaults
extension SettingsViewController {
    
    
    func setUserDefaults(switchVal:Bool) {
        if switchVal {
            defaults.set(true, forKey: "isSettingsOn")
        } else {
            defaults.set(false, forKey: "isSettingsOn")
        }
    }
    
    
    func getSettingsIsOnStatus() -> Bool {
        guard let isSettingsOn = defaults.bool(forKey: "isSettingsOn") as? Bool else {
            return false
        }
        return isSettingsOn
    }
    
}


