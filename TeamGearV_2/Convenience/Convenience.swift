//
//  Convenience.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 4/1/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import Foundation

class Convenience {
    
    static func formatTheDate(date:NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        return dateFormatter.string(from: date as! Date)
    }
    
    
    static func formatForComparison(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formatEndDate = dateFormatter.string(from: date)
        return formatEndDate
    }
    
   
}
