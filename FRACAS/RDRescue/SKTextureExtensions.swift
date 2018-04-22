//
//  SKTextureExtensions.swift
//  RDRescue
//
//  Created by James Marshall on 17/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

extension SKTexture {
    class func flipImage(name:String,flipHoriz:Bool,flipVert:Bool)->SKTexture {
        if !flipHoriz && !flipVert {
            return SKTexture.init(imageNamed: name)
        }
        let image = UIImage(named:name)
        
        UIGraphicsBeginImageContext(image!.size)
        let context = UIGraphicsGetCurrentContext()
        
        if !flipHoriz && flipVert {
            // Do nothing, X is flipped normally in a Core Graphics Context
            // but in landscape is inverted so this is Y
        } else
            if flipHoriz && !flipVert{
                // fix X axis but is inverted so fix Y axis
                CGContextTranslateCTM(context!, 0, image!.size.height)
                CGContextScaleCTM(context!, 1.0, -1.0)
                // flip Y but is inverted so flip X here
                CGContextTranslateCTM(context!, image!.size.width, 0)
                CGContextScaleCTM(context!, -1.0, 1.0)
            } else
                if flipHoriz && flipVert {
                    // flip Y but is inverted so flip X here
                    CGContextTranslateCTM(context!, image!.size.width, 0)
                    CGContextScaleCTM(context!, -1.0, 1.0)
        }
        
        CGContextDrawImage(context, CGRectMake(0.0, 0.0, image!.size.width, image!.size.height), image!.cgImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return SKTexture(image: newImage)
    }
}
