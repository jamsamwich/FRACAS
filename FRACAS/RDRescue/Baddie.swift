//
//  baddie.swift
//  RDRescue
//
//  Created by James Marshall on 14/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//


import SpriteKit
import Foundation

class Baddie : CharacterBase{
    
    //variables
   
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //buildCharacter()
        AI = true
    }
    
    
    func buildCharacter() {
        switch type {
        case .grub:
            WalkingFramesRight.append(SKTexture(imageNamed: "grub_horizontal_1"))
            WalkingFramesRight.append(SKTexture(imageNamed: "grub_horizontal_2"))
            
            WalkingFramesLeft.append(SKTexture(imageNamed: "grub_horizontal_1"))
            WalkingFramesLeft.append(SKTexture(imageNamed: "grub_horizontal_2"))
            
            WalkingFramesUp.append(SKTexture(imageNamed: "grub_vertical_1"))
            WalkingFramesUp.append(SKTexture(imageNamed: "grub_vertical_2"))
            
            WalkingFramesDown.append(SKTexture(imageNamed: "grub_vertical_3"))
            WalkingFramesDown.append(SKTexture(imageNamed: "grub_vertical_4"))
            
            leftTexture = SKTexture(imageNamed: "grub_horizontal_1")
            rightTexture = SKTexture(imageNamed: "grub_horizontal_1")
            upTexture = SKTexture(imageNamed: "grub_vertical_1")
            downTexture = SKTexture(imageNamed: "grub_vertical_3")
        case .greenMan:
            WalkingFramesRight.append(SKTexture(imageNamed: "grub_horizontal_1"))
            WalkingFramesRight.append(SKTexture(imageNamed: "grub_horizontal_2"))
            
            WalkingFramesLeft.append(SKTexture(imageNamed: "grub_horizontal_1"))
            WalkingFramesLeft.append(SKTexture(imageNamed: "grub_horizontal_2"))
            
            WalkingFramesUp.append(SKTexture(imageNamed: "grub_vertical_1"))
            WalkingFramesUp.append(SKTexture(imageNamed: "grub_vertical_2"))
            
            WalkingFramesDown.append(SKTexture(imageNamed: "grub_vertical_3"))
            WalkingFramesDown.append(SKTexture(imageNamed: "grub_vertical_4"))
            
            leftTexture = SKTexture(imageNamed: "grub_horizontal_1")
            rightTexture = SKTexture(imageNamed: "grub_horizontal_1")
            upTexture = SKTexture(imageNamed: "grub_vertical_1")
            downTexture = SKTexture(imageNamed: "grub_vertical_3")
        case .blueEyedFrog:
            
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog"))
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog"))
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog2"))
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog2"))
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog3"))
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog3"))
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog"))
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog"))
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog3"))
            WalkingFramesRight.append(SKTexture(imageNamed: "blueEyedFrog3"))
            
            WalkingFramesLeft = WalkingFramesRight
            WalkingFramesUp = WalkingFramesRight
            WalkingFramesDown = WalkingFramesRight
            
           
            
            leftTexture = SKTexture(imageNamed: "blueEyedFrog")
            rightTexture = SKTexture(imageNamed: "blueEyedFrog")
            upTexture = SKTexture(imageNamed: "blueEyedFrog")
            downTexture = SKTexture(imageNamed: "blueEyedFrog")
        case .wizard:
            return
        }
       
        
        moveSpeed = 0.36
    }
}
