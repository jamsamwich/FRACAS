//
//  CharacterBase.swift
//  RDRescue
//
//  Created by James Marshall on 15/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CharacterBase : SKSpriteNode {
    
    var WalkingFramesRight: [SKTexture] = []
    var WalkingFramesLeft: [SKTexture] = []
    var WalkingFramesUp: [SKTexture] = []
    var WalkingFramesDown: [SKTexture] = []
    
    var leftTexture : SKTexture!
    var rightTexture : SKTexture!
    var upTexture : SKTexture!
    var downTexture : SKTexture!
    var path : [coordinates]!
    var pathCount : Int{
        get{
            return path.count
        }
    }
    var type : characterType = .wizard
    var interruptNode : coordinates!
    var moveSpeed : Double = 0.0
    var frameSpeed : Double {
        get{
            if type == .blueEyedFrog{
                return 0.1 * moveSpeed
            }
            else{
                return 0.5 * moveSpeed
            }
            
        }
    }
    var AI : Bool = false
    var doneMoving : Bool = true
    var died : Bool = false
    var _lastDirection : Direction = .right
    var lastDirection : Direction {
        get{
            return _lastDirection
        }
        set{
            _lastDirection = newValue
            switch newValue {
            case .left:
                self.texture = leftTexture
            case .right:
                self.texture = rightTexture
            case .up:
                self.texture = upTexture
            case .down:
                self.texture = downTexture
            case .stationary:
                self.texture = leftTexture
            }
        }
    }
    
    func animationAction(direction : Direction) -> SKAction!{
        if direction != Direction.stationary{
            
            switch direction{
            case Direction.left:
                return SKAction.animate(with: WalkingFramesLeft,
                                     timePerFrame: frameSpeed,
                                     resize: false,
                                     restore: true)
            case Direction.right:
                return SKAction.animate(with: WalkingFramesRight,
                                     timePerFrame: frameSpeed,
                                     resize: false,
                                     restore: true)
            case Direction.up:
                return SKAction.animate(with: WalkingFramesUp,
                                     timePerFrame: frameSpeed,
                                     resize: false,
                                     restore: true)
            case Direction.down:
                return SKAction.animate(with: WalkingFramesDown,
                                     timePerFrame: frameSpeed,
                                     resize: false,
                                     restore: true)
            case Direction.stationary:
                return nil
            }
            
            
        }
        else{
            self.removeAllActions()
        }
        return nil
    }
    
}
