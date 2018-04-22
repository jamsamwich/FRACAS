//
//  baddieTypes.swift
//  FRACAS
//
//  Created by James Marshall on 23/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
enum characterType : String {
    case wizard
    case grub
    case greenMan
    case blueEyedFrog
    
    var description: String {
        return self.rawValue
    }
}
