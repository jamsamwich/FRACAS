//
//  LevelSelector.swift
//  RDRescue
//
//  Created by James Marshall on 13/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class LevelSelector : SKScene{
    
     var backButton : SKLabelNode!
    
     var levelLabel : SKLabelNode!
     var playButton : SKLabelNode!
     var nextLevel : SKLabelNode!
     var previousLevel : SKLabelNode!
    var sceneFrame : SKShapeNode!
     var level : Int = 1
    
     var purpleGate : SKSpriteNode!
     var redGate : SKSpriteNode!
     var purpleWizard : SKSpriteNode!
     var redWizard : SKSpriteNode!
     var y : CGFloat = 0
     var selectedColour : wizardColour = .none
    var soundGenerator : SKSpriteNode = SKSpriteNode()
    
    func navigateToScene(name : String){
        
        let transition:SKTransition = SKTransition.fade(withDuration : 1)
        if let scene:GameScene = GameScene(fileNamed: name){
            scene.selectedWizardColour = selectedColour
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    func setSceneSize(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let scaleFactor = screenWidth/812
        sceneFrame.xScale = scaleFactor
        sceneFrame.yScale = scaleFactor
    }
    
    override func didMove(to view: SKView) {
        createButton()
        
        let bounceFactor : CGFloat = 0.2
        playButton.fontColor = UIColor.gray
        
        previousLevel.isHidden = true
        
        
        y = purpleGate.position.y
        
        let dropAction : SKAction = SKAction.sequence([SKAction.group([SKAction.moveBy(x: 0, y: -purpleGate.size.height, duration: 0.5),SKAction.speed(by: 2, duration: 0.2)]),
                                                       SKAction.playSoundFileNamed("doorBang.m4a", waitForCompletion: false)])
        
        let bounce : SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: purpleGate.size.height*bounceFactor, duration: 0.5),
                                                   SKAction.moveBy(x: 0, y: -purpleGate.size.height*bounceFactor, duration: 0.4),
                                                    SKAction.playSoundFileNamed("doorBang.m4a", waitForCompletion: false),
                                                   SKAction.moveBy(x: 0, y: purpleGate.size.height*bounceFactor/2, duration: 0.3),
                                                   SKAction.moveBy(x: 0, y: -purpleGate.size.height*bounceFactor/3, duration: 0.2),
                                                   SKAction.playSoundFileNamed("doorBang.m4a", waitForCompletion: false)])
        redGate.run(SKAction.sequence([dropAction, bounce]))
        purpleGate.run(SKAction.sequence([dropAction, bounce]))
    }
    
    func createButton()
    {
            addChild(soundGenerator)
        guard let sceneFrame = childNode(withName: "frame") as? SKShapeNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.sceneFrame = sceneFrame
        
        setSceneSize()
        
        guard let backButton = sceneFrame.childNode(withName: "backButton") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.backButton = backButton
        
        guard let levelLabel = sceneFrame.childNode(withName: "levelLabel") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.levelLabel = levelLabel
        
        guard let playButton = sceneFrame.childNode(withName: "playButton") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.playButton = playButton
        
        guard let nextLevel = sceneFrame.childNode(withName: "nextLevel") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.nextLevel = nextLevel
        
        guard let previousLevel = sceneFrame.childNode(withName: "previousLevel") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.previousLevel = previousLevel
        
        guard let purpleGate = sceneFrame.childNode(withName: "purpleGate") as? SKSpriteNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.purpleGate = purpleGate
        
        guard let redGate = sceneFrame.childNode(withName: "redGate") as? SKSpriteNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.redGate = redGate
        
        guard let purpleWizard = sceneFrame.childNode(withName: "purpleWizard") as? SKSpriteNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.purpleWizard = purpleWizard
        
        guard let redWizard = sceneFrame.childNode(withName: "redWizard") as? SKSpriteNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.redWizard = redWizard
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: sceneFrame)
       
        
        if backButton.contains(touchLocation) {
            //go back to menu
            let transition:SKTransition = SKTransition.fade(withDuration : 1)
            if let levelScene:SKScene = SKScene(fileNamed: "Menu"){
                self.view?.presentScene(levelScene, transition: transition)
            }
            
        }
            
        else if playButton.contains(touchLocation) {
            //go to level selector
            
            if selectedColour != .none{
                navigateToScene(name: "Level" + String(level))
            }
        }
            
        else if nextLevel.contains(touchLocation) {
            if level < 10{
                level += 1
                levelLabel.text = "LEVEL " + String(level)
            }
            if level < 10{
                nextLevel.isHidden = false
            }
            else{
                nextLevel.isHidden = true
            }
            if level > 1{
                previousLevel.isHidden = false
            }
            else{
                previousLevel.isHidden = true
            }
        }
        
        else if previousLevel.contains(touchLocation) {
            if level > 1{
                level -= 1
                levelLabel.text = "LEVEL " + String(level)
            }
            if level < 3{
                nextLevel.isHidden = false
            }
            else{
                nextLevel.isHidden = true
            }
            if level > 1{
                previousLevel.isHidden = false
            }
            else{
                previousLevel.isHidden = true
            }
        }
        
        else if purpleGate.contains(touchLocation)  || purpleWizard.contains(touchLocation){
            //set purple wizard
            
                if selectedColour == .red{
                    //close red
                    let newpoint : CGPoint = CGPoint(x: redGate.position.x, y: y - redGate.size.height)
                    let openGate : SKAction = SKAction.sequence([SKAction.move(to: newpoint, duration: 0.8),
                                                                 SKAction.playSoundFileNamed("doorBang.m4a", waitForCompletion: false)])
                    redGate.run(openGate)
                    //open purple
                    let newpoint2 : CGPoint = CGPoint(x: purpleGate.position.x, y: purpleGate.position.y + purpleGate.size.height)
                    let openGate2 : SKAction = SKAction.move(to: newpoint2, duration: 0.8)
                    purpleGate.run(openGate2)
                    
                    selectedColour = .purple
                }
                else if selectedColour == .purple{
                    //close purple
                    let newpoint : CGPoint = CGPoint(x: purpleGate.position.x, y: y - purpleGate.size.height)
                    let openGate : SKAction = SKAction.sequence([SKAction.move(to: newpoint, duration: 0.8),
                                                                 SKAction.playSoundFileNamed("doorBang.m4a", waitForCompletion: false)])
                    purpleGate.run(openGate)
                    
                    selectedColour = .none
                }
                else if selectedColour == .none{
                    //open purple
                    let newpoint : CGPoint = CGPoint(x: purpleGate.position.x, y: y + purpleGate.size.height)
                    let openGate : SKAction = SKAction.move(to: newpoint, duration: 0.8)
                    purpleGate.run(openGate)
                    
                    selectedColour = .purple
                   
        }
        }
        
        else if redGate.contains(touchLocation) || redWizard.contains(touchLocation){
            //set purple wizard
            
                if selectedColour == .red{
                    //close red
                    let newpoint : CGPoint = CGPoint(x: redGate.position.x, y: y - redGate.size.height)
                    let openGate : SKAction = SKAction.sequence([SKAction.move(to: newpoint, duration: 0.8),
                                                                 SKAction.playSoundFileNamed("doorBang.m4a", waitForCompletion: false)])
                    redGate.run(openGate)
                    selectedColour = .none
                }
                else if selectedColour == .purple{
                    //close purple
                    let newpoint : CGPoint = CGPoint(x: purpleGate.position.x, y: y - purpleGate.size.height)
                    let openGate : SKAction = SKAction.sequence([SKAction.move(to: newpoint, duration: 0.8),
                                                                 SKAction.playSoundFileNamed("doorBang.m4a", waitForCompletion: false)])
                    purpleGate.run(openGate)
                    
                    let newpoint2 : CGPoint = CGPoint(x: redGate.position.x, y: y + redGate.size.height)
                    let openGate2 : SKAction = SKAction.move(to: newpoint2, duration: 0.8)
                    redGate.run(openGate2)
                    
                    selectedColour = .red
                }
                else if selectedColour == .none{
                    //open red
                    let newpoint : CGPoint = CGPoint(x: redGate.position.x, y: y + redGate.size.height)
                    let openGate : SKAction = SKAction.move(to: newpoint, duration: 0.8)
                    redGate.run(openGate)
                    selectedColour = .red
            }
                
            
            
            
            
      
        }
        if selectedColour != .none{
            playButton.fontColor = UIColor.white
        }
        else{
            playButton.fontColor = UIColor.gray
        }
    }
}
