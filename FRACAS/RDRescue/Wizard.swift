//
//  Wizard.swift
//  RDRescue
//
//  Created by James Marshall on 02/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import SpriteKit
import Foundation


class Wizard : CharacterBase{
    
    //variables
    var lives : Int = 3
    var colour : wizardColour = .purple
    var numberOfBombs : Int = 1
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    func buildCharacter() {
        WalkingFramesLeft.append(SKTexture(imageNamed: colour.description + "_wizard_sideways_1"))
        WalkingFramesLeft.append(SKTexture(imageNamed: colour.description + "_wizard_sideways_2"))
    
        WalkingFramesRight.append(SKTexture(imageNamed: colour.description + "_wizard_sideways_3"))
        WalkingFramesRight.append(SKTexture(imageNamed: colour.description + "_wizard_sideways_4"))
        
        WalkingFramesUp.append(SKTexture(imageNamed: colour.description + "_wizard_up_1"))
        WalkingFramesUp.append(SKTexture(imageNamed: colour.description + "_wizard_up_2"))
        
        WalkingFramesDown.append(SKTexture(imageNamed: colour.description + "_wizard_down_1"))
        WalkingFramesDown.append(SKTexture(imageNamed: colour.description + "_wizard_down_2"))
        
        leftTexture = SKTexture(imageNamed: colour.description + "_wizard_sideways_1")
        rightTexture = SKTexture(imageNamed: colour.description + "_wizard_sideways_3")
        upTexture = SKTexture(imageNamed: colour.description + "_wizard_up_1")
        downTexture = SKTexture(imageNamed: colour.description + "_wizard_down_1")
        print(colour.description + "_wizard_down_1")
        self.texture = rightTexture
        
        moveSpeed = 0.18
    }
    
}



