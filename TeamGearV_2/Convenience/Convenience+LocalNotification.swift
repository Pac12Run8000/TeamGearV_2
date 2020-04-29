//
//  Convenience+LocalNotification.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 4/4/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import Foundation
import UserNotifications


extension Convenience {
    
    static func setNotification(startDate:Date, endDate:Date, title:String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "The item:\(title) was loaned out on \(formatTheDate(date: startDate as NSDate)) and is due to be returned now."
        content.sound = .defaultCriticalSound(withAudioVolume: 30.0)
//        let mydate = Calendar.current.date(byAdding: .minute, value: 1, to:endDate)
//        let mydate = Calendar.current.date(bys)
        
        let mydate = endDate
        
        let mydateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: mydate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: mydateComponents, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request) { (error) in
            guard error == nil else {
                print("There was an error:", error?.localizedDescription)
                return
            }
            
            
            
            
        }
    }
    
}
