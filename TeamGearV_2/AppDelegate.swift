//
//  AppDelegate.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 3/29/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            guard error == nil else {
                print("There was an error requesting authorization:\(error?.localizedDescription)")
                return
            }
            
            guard granted else {
                print("Permission was not granted")
                return
            }
            
            print("Permission was granted")
            
            
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    lazy var persistantContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TeamGearV_2")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("There was an error:\(error.localizedDescription)")
            }
        }
        return container
    }()


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge, .alert, .sound])
    }
    
}
