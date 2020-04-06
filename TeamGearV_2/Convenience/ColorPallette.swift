//
//  ColorPallette.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 4/5/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import UIKit

extension UIColor {
    
    
    static let pinkish = UIColor.colorFromHex("BF88B6")
    static let darkBlue = UIColor.colorFromHex("131A40")
    static let darkBlue_1 = UIColor.colorFromHex("355B8C")
    static let darkBlue_2 = UIColor.colorFromHex("17AEBF")
    static let darkBlue_3 = UIColor.colorFromHex("30F2F2")
    
    
    static func colorFromHex(_ hex:String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (hexString.hasPrefix("#")) {
            hexString.remove(at: hexString.startIndex)
        }
        
        if (hexString.count != 6) {
            return UIColor.black
        }
        
        var rgb:UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: 1.0)
        
    }
    
    
    
}

