//
//  Menu.swift
//  RDRescue
//
//  Created by James Marshall on 13/03/2018.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Menu : SKScene{
    var button : SKLabelNode!
    var timer = Timer()
    var sceneFrame : SKShapeNode!
    var soundGenerator : SKSpriteNode = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        createButton()
       //getRandomColor()
    }
    
    func setSceneSize(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let scaleFactor = screenWidth/812
        sceneFrame.xScale = scaleFactor
        sceneFrame.yScale = scaleFactor
    }
    
    func createButton()
    {
            addChild(soundGenerator)
        soundGenerator.run(SKAction.playSoundFileNamed("into.m4a", waitForCompletion: false))
        guard let sceneFrame = childNode(withName: "frame") as? SKShapeNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.sceneFrame = sceneFrame
        
        setSceneSize()
        
        guard let button = sceneFrame.childNode(withName: "button") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.button = button
        
    }
    
    func navigateToScene(name : String){
        
        let transition:SKTransition = SKTransition.fade(withDuration : 1)
        if let scene:SKScene = SKScene(fileNamed: name){
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: sceneFrame)
        // Check if the location of the touch is within the button's bounds
        if button.contains(touchLocation) {
            //go to level selector
            navigateToScene(name: "LevelSelector")
            
        }
        
    }
    
     func updateTimer() {
        getRandomColor()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func getRandomColor() {
        let red   = CGFloat((arc4random() % 256)) / 255.0
        let green = CGFloat((arc4random() % 256)) / 255.0
        let blue  = CGFloat((arc4random() % 256)) / 255.0
        let alpha = CGFloat(1.0)
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options:[.repeat, .autoreverse], animations: {
           
            self.backgroundColor = UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        }, completion:nil)
    }
}
