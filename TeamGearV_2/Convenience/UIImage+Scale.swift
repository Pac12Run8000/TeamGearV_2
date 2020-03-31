//
//  UIImage+Scale.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 3/30/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    fileprivate class func scaleImageToSize (image:UIImage, toSize size:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func scaleImage (image:UIImage, toWidth width:CGFloat, andHeight heigt:CGFloat) -> UIImage? {
        let oldWidth = image.size.width
        let oldHeight = image.size.height
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : heigt / oldHeight
        
        let newHeight = oldHeight * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        return UIImage.scaleImageToSize(image: image, toSize: newSize)
    }
}

