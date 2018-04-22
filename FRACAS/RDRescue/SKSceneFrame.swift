//
//  SKSceneFrame.swift
//  FRACAS
//
//  Created by James Marshall on 23/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
import SpriteKit

class SKSceneFrame : SKShapeNode{
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       setSceneSize()
    }
    
    func setSceneSize(){
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //let sceneHeight = scene.size.height * (scene.size.height/screenHeight)
        
    }
}
