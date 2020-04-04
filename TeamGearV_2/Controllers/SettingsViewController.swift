//
//  SettingsViewController.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 4/3/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsControlOutlet: UISwitch!
    
    var managedObjectContext:NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistantContainer.viewContext
        
        settingsControlOutlet.isOn = getBoolValForUserNotifications()
        
    }
    

   

}

// MARK:- CoreData functionality
extension SettingsViewController {
    
    func getBoolValForUserNotifications() -> Bool {
        let userNotification = UserNotifications(context: managedObjectContext!)
        guard let isInUse = userNotification.isInUse as? Bool else {
            print("Could not get value for user notification.")
            return false
        }
        return isInUse
    }
    
}
