//
//  Directions.swift
//  RDRescue
//
//  Created by James Marshall on 11/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
enum Direction : String {
    case left
    case right
    case up
    case down
    case stationary
    
    var description: String {
        return self.rawValue
    }
}
