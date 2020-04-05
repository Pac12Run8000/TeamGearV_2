//
//  SettingsViewController.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 4/3/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import UIKit
import UserNotifications


class SettingsViewController: UIViewController {
    
    var isSettingsOn:Bool?
    var defaults:UserDefaults!
    
    @IBOutlet weak var settingsControlOutlet: UISwitch!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        
        settingsControlOutlet.isOn = getSettingsIsOnStatus()

        // ----------------------------
        
        
        
        if getSettingsIsOnStatus() {
            print("Call the local notification.")
            
        } else {
            print("No notification")
        }
        
        
        
        
    }
    
    @IBAction func settingsControllerAction(_ sender: UISwitch) {
        setUserDefaults(switchVal: sender.isOn)
        if getSettingsIsOnStatus() {
            print("Call the local notification.")
            
        } else {
            print("No notification")
        }
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



