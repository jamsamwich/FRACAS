//
//  SKButton.swift
//  RDRescue
//
//  Created by James Marshall on 18/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
import SpriteKit

class SKButton: SKNode {
    var defaultButton: SKSpriteNode
    var activeButton: SKSpriteNode
    var action: () -> Void
    
    init(defaultButtonImage: String, activeButtonImage: String, buttonAction: @escaping () -> Void) {
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        activeButton = SKSpriteNode(imageNamed: activeButtonImage)
        activeButton.isHidden = true
        action = buttonAction
        
        super.init()
        
        isUserInteractionEnabled = true
        addChild(defaultButton)
        addChild(activeButton)
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeButton.isHidden = false
        defaultButton.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        var location: CGPoint = touch!.location(in: self)
        
        if defaultButton.contains(location) {
            activeButton.isHidden = false
            defaultButton.isHidden = true
        } else {
            activeButton.isHidden = true
            defaultButton.isHidden = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        var location: CGPoint = touch!.location(in: self)
        
        if defaultButton.contains(location) {
            action()
        }
        activeButton.isHidden = true
        defaultButton.isHidden = false
    }
    
    
   
}
