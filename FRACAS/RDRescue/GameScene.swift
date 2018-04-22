/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
    // variables
    var bombsList: [Bomb] = []
    var fireList: [Fire] = []
    var prizeList: [Prize] = []
    var tileSize : Double = 0
    var score : Double = 0.0
    var timer = Timer()
    var checker = Timer()
    var lifeCount = SKLabelNode()
    var gameOver = SKLabelNode()
    var selectedWizardColour : wizardColour = .purple
    var spikeCount = 0.0
    var won : Bool = false
    var levelNumber : Int = 0
    var newBomb : Bool = false
    // touch locations
    var targetLocation: CGPoint = .zero
    var stepLocation: CGPoint = .zero
  
    
    
    
    // Scene Nodes
    var sceneFrame : SKShapeNode!
    var soundGenerator : SKSpriteNode = SKSpriteNode()
    var wizard:Wizard!
    var baddies : [Baddie] = []
    var landBackground:SKTileMapNode!
    var objectsMap:SKTileMapNode!
    var effectsMap:SKTileMapNode!
    var lblScore:SKLabelNode!
    var seconds = 60
    var menuButton : SKLabelNode!
    var quitButton : SKLabelNode!
    var closeButton : SKLabelNode!
    var menu : SKShapeNode!
    var itemBox : SKSpriteNode!
    var currentItem : SKSpriteNode!
    var startingPosition : CGPoint!
    var winningTile : CGPoint!
    
    
    var graph : GKGridGraph<GKGridGraphNode>!
    var graphBeforeBomb : GKGridGraph<GKGridGraphNode>!
    
    override func didMove(to view: SKView) {
        loadSceneNodes()
        setGraph()
        runTimer()
        runChecker()
        targetLocation = wizard.position
        startingPosition = wizard.position
        addChild(soundGenerator)
        var button: SKButton = SKButton(defaultButtonImage: "button", activeButtonImage: "buttonPressed", buttonAction: performMagic)
        button.position = CGPoint(x: -329.928, y: -106.981)
        button.zPosition = 5
        sceneFrame.addChild(button)
        
        var buttonBomb: SKButton = SKButton(defaultButtonImage: "buttonBomb", activeButtonImage: "buttonBombPressed", buttonAction: layBomb)
        buttonBomb.position = CGPoint(x: -329.928, y: 19.5)
        sceneFrame.addChild(buttonBomb)
        buttonBomb.zPosition = 5
        
    }
   
    func setSceneSize(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let scaleFactor = screenWidth/812
        sceneFrame.xScale = scaleFactor
        sceneFrame.yScale = scaleFactor
    }
    
    func wonLevel(){
        if won == false{
            won = true
            var locations : [CGPoint] = []
            
            for column in 0..<landBackground.numberOfColumns
            {
                for row in 0..<landBackground.numberOfRows
                {
                    if let tile:SKTileDefinition? = landBackground.tileDefinition(atColumn: column, row: row){
                        print(tile?.name)
                        if tile != nil { //is corridor
                            
                            if(AnimtaedObjectTileType(row: row, column: column) != TileType.boulder &&
                                AnimtaedObjectTileType(row: row, column: column) != TileType.boulder2 &&
                                AnimtaedObjectTileType(row: row, column: column) != TileType.boulder3){ //is not obstructed
                                
                                locations.append(landBackground.centerOfTile(atColumn: column, row: row))
                            }
                            
                            
                        }
                    }
                    
                }
            }
            
            let randomNum:UInt32 = arc4random_uniform(UInt32(locations.count))
            let someInt:Int = Int(randomNum)
            
            if let particles = SKEmitterNode(fileNamed: "fog.sks") {
                particles.position = locations[someInt]
                particles.position = CGPoint(x: particles.position.x, y: particles.position.y - (landBackground.tileSize.height/2))
                particles.zPosition = 30
                addChild(particles)
                winningTile = locations[someInt]
            }
        }
       
    }
    
    func layBomb(){
            //lay bomb
        if wizard.numberOfBombs > 0{
            setGraph()
            soundGenerator.run(SKAction.playSoundFileNamed("layBomb.m4a", waitForCompletion: false))
            newBomb = true
            let currentColumn = landBackground.tileColumnIndex(fromPosition: wizard.position)
            let currentRow = landBackground.tileRowIndex(fromPosition: wizard.position)
            SetTile(tile: TileType.bomb, row: currentRow, column: currentColumn)
            AddBomb(row: currentRow, column: currentColumn)
            
            var index : Int = 0
            
            for baddie in baddies{
                index = 0
                if let path = baddie.path{
                    for coord in 0..<baddie.pathCount
                    {
                        if baddie.path[coord].row == currentRow && baddie.path[coord].column == currentColumn{ //bomb is in the path
                            index = coord
                        }
                    }
                    if index > 0{
                        baddie.interruptNode = baddie.path[index - 1]
                    }
                }
            }
        }
    }
    
    func performMagic(){
        
    }
    
    func setGraph(){
        
        if graph != nil{
             graphBeforeBomb = graph
        }
        graph = GKGridGraph(fromGridStartingAt: vector_int2(0,0), width: Int32(landBackground.numberOfColumns), height: Int32(landBackground.numberOfRows), diagonalsAllowed: false)
        
        var obstacles = [GKGridGraphNode]()
        
        for column in 0..<landBackground.numberOfColumns
        {
            for row in 0..<landBackground.numberOfRows
            {
                let position = landBackground.centerOfTile(atColumn: column, row: row)
                
                if let tile:SKTileDefinition? = landBackground.tileDefinition(atColumn: column, row: row){
                    print(tile?.name)
                    if tile == nil {
                        let wallNode = graph.node(atGridPosition: vector_int2(Int32(column),Int32(row)))!
                        obstacles.append(wallNode)
                    }
                }
                if(AnimtaedObjectTileType(row: row, column: column) == TileType.boulder ||
                    AnimtaedObjectTileType(row: row, column: column) == TileType.boulder2 ||
                    AnimtaedObjectTileType(row: row, column: column) == TileType.boulder3){
                    let wallNode = graph.node(atGridPosition: vector_int2(Int32(column),Int32(row)))!
                    obstacles.append(wallNode)
                    
                }
                if(ObjectTileType(row: row, column: column) == TileType.bomb){
                    let wallNode = graph.node(atGridPosition: vector_int2(Int32(column),Int32(row)))!
                    obstacles.append(wallNode)
                    
                }
            }
        }
        graph.remove(obstacles)
    }
    
    func loadSceneNodes() {
        
        guard let sceneFrame = childNode(withName: "frame") as? SKShapeNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.sceneFrame = sceneFrame
        
        setSceneSize()
        
        guard let wizard = sceneFrame.childNode(withName: "car") as? Wizard else {
            fatalError("Sprite Nodes not loaded")
        }
        wizard.colour = selectedWizardColour
        self.wizard = wizard
        wizard.buildCharacter()
        
        var baddieNumber : Int = 1
        var baddieExists : Bool = false
        
        //look for 1st baddie
        
        if let baddie = sceneFrame.childNode(withName: "grub1") as? Baddie {
            baddieExists = true
        }
        while baddieExists{
            if let baddie = sceneFrame.childNode(withName: "grub" + String(baddieNumber)) as? Baddie {
                baddieExists = true
                baddieNumber += 1
                baddie.type = .grub
                baddie.buildCharacter()
                self.baddies.append(baddie)
            }
            else{
                baddieExists = false
            }
        }
        
        if let baddie = sceneFrame.childNode(withName: "blueEyedFrog1") as? Baddie {
            baddieExists = true
        }
        while baddieExists{
            if let baddie = sceneFrame.childNode(withName: "blueEyedFrog" + String(baddieNumber)) as? Baddie {
                baddieExists = true
                baddieNumber += 1
                baddie.type = .blueEyedFrog
                baddie.buildCharacter()
                self.baddies.append(baddie)
            }
            else{
                baddieExists = false
            }
        }
        if let baddie = sceneFrame.childNode(withName: "greenMan1") as? Baddie {
            baddieExists = true
        }
        while baddieExists{
            if let baddie = sceneFrame.childNode(withName: "greenMan" + String(baddieNumber)) as? Baddie {
                baddieExists = true
                baddieNumber += 1
                baddie.type = .greenMan
                baddie.buildCharacter()
                self.baddies.append(baddie)
            }
            else{
                baddieExists = false
            }
        }
        
        
        
        guard let lblScore = sceneFrame.childNode(withName: "lblScore") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.lblScore = lblScore
        guard let landBackground = sceneFrame.childNode(withName: "Floor layer")
            as? SKTileMapNode else {
                fatalError("Background node not loaded")
        }
        self.landBackground = landBackground
        guard let objectsMap = sceneFrame.childNode(withName: "Objects layer")
            as? SKTileMapNode else {
                fatalError("Background node not loaded")
        }
        self.objectsMap = objectsMap
        guard let effectsMap = sceneFrame.childNode(withName: "Effects layer")
            as? SKTileMapNode else {
                fatalError("Background node not loaded")
        }
        self.effectsMap = effectsMap
        guard let lifeCount = sceneFrame.childNode(withName: "lifeCount")
            as? SKLabelNode else {
                fatalError("label not found")
        }
        self.lifeCount = lifeCount
        lifeCount.text = "X " + String(wizard.lives)
        guard let gameOver = sceneFrame.childNode(withName: "gameOver")
            as? SKLabelNode else {
                fatalError("label not found")
        }
        self.gameOver = gameOver
        guard let menuButton = sceneFrame.childNode(withName: "menuButton") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.menuButton = menuButton
        
        guard let menu = sceneFrame.childNode(withName: "menu") as? SKShapeNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.menu = menu
        
        guard let quitButton = menu.childNode(withName: "quitButton") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.quitButton = quitButton
        guard let closeButton = menu.childNode(withName: "closeButton") as? SKLabelNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.closeButton = closeButton
      
        guard let itemBox = sceneFrame.childNode(withName: "item") as? SKSpriteNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.itemBox = itemBox
        guard let currentItem = sceneFrame.childNode(withName: "currentItem") as? SKSpriteNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.currentItem = currentItem
        tileSize = Double(landBackground.tileSize.height)
    }
    
    func AddBomb(row: Int, column : Int){
        let bomb : Bomb = Bomb()
        bomb.id = bombsList.count + 1
        bomb.row = row
        bomb.column = column
        bomb.time = 5
        bombsList.append(bomb)
        wizard.numberOfBombs -= 1
    }
    
    func AddFire(row: Int, column : Int, destroyedBoulder : Bool, destroyedCharacter : CharacterBase? = nil){
        let fire : Fire = Fire()
        fire.id = fireList.count + 1
        fire.row = row
        fire.column = column
        fire.destroyedCharacter = destroyedCharacter
        if destroyedCharacter != nil{
            fire.time = 3
        }
        else{
            fire.time = 1
        }
        fire.destroyedBoulder = destroyedBoulder
        fireList.append(fire)
    }
    
    func AddPrize(row: Int, column : Int, type : TileType){
        let prize : Prize = Prize()
        prize.id = fireList.count + 1
        prize.row = row
        prize.column = column
        prize.type = type
        prizeList.append(prize)
    }
    
    func SetTile(tile : TileType, row: Int, column : Int, destroyedBoulder : Bool = false, destroyedCharacter : CharacterBase? = nil){
        guard let tileSet = SKTileSet(named: "Sample Grid Tile Set") else {
            fatalError("Object Tiles Tile Set not found")
        }
        let tileGroups = tileSet.tileGroups
        print(tile.description)
        let tileToSet = tileGroups.first(where: {$0.name == tile.description})
        
        if(tile == TileType.fire){
            effectsMap.setTileGroup(tileToSet, forColumn: column, row: row)
        }
        else{
            objectsMap.setTileGroup(tileToSet, forColumn: column, row: row)
        }
        
        if tile == TileType.fire_vertical || tile == TileType.fire_horizontal ||
           tile == TileType.fire_end_top || tile == TileType.fire_end_bottom ||
           tile == TileType.fire_end_left || tile == TileType.fire_end_right ||
           tile == TileType.fire_t_left || tile == TileType.fire_t_right ||
           tile == TileType.fire_t_top || tile == TileType.fire_t_bottom ||
           tile == TileType.fire_x || tile == TileType.fire_bend_bottom_left ||
           tile == TileType.fire_bend_bottom_right  || tile == TileType.fire_bend_top_left ||
           tile == TileType.fire_bend_top_right || tile == .fire_bend_top_right{
            AddFire(row: row, column: column, destroyedBoulder : destroyedBoulder)
        }
        else if tile == .fire{
            AddFire(row: row, column: column, destroyedBoulder : destroyedBoulder, destroyedCharacter: destroyedCharacter)
        }
         setGraph()
    }
    
    func BackgroundTileType(row : Int, column : Int) -> TileType{
        if let tile:SKTileDefinition? = landBackground.tileDefinition(atColumn: column, row: row){
            if let tileName = tile?.name{
                return TileType(rawValue: tileName)!
            }
        }
        return TileType.empty
    }
    func ObjectTileType(row : Int, column : Int) -> TileType{
        if let tile:SKTileDefinition? = objectsMap.tileDefinition(atColumn: column, row: row){
            if let tileName = tile?.name{
                print(tileName)
                return TileType(rawValue: tileName)!
            }
        }
        return TileType.empty
    }
    
    func AnimtaedObjectTileType(row : Int, column : Int) -> TileType{
        if let tile:SKTileDefinition? = objectsMap.tileDefinition(atColumn: column, row: row){
            if let key = tile?.userData?.value(forKey: "type") as? String{
                return TileType(rawValue: key)!
            }
        }
        return TileType.empty
    }
    
    func IsOpenPassage(row : Int, column : Int) -> Bool{
        if(BackgroundTileType(row: row, column: column) == TileType.floo_top || BackgroundTileType(row: row, column: column) == TileType.floor_left || BackgroundTileType(row: row, column: column) == TileType.floor_top_end || BackgroundTileType(row: row, column: column) == TileType.floor_left_top || BackgroundTileType(row: row, column: column) == TileType.floor_top_start || BackgroundTileType(row: row, column: column) == TileType.floor_left_start
            
            || BackgroundTileType(row: row, column: column) == TileType.floor_left_start_2
            || BackgroundTileType(row: row, column: column) == TileType.floor_left_top_2
            || BackgroundTileType(row: row, column: column) == TileType.floor_top_end_2
            || BackgroundTileType(row: row, column: column) == TileType.floor_top_start_2)
            {
                if(column <= landBackground.numberOfColumns || column >= 0 && row <= landBackground.numberOfRows || row >= 0)
                {
                return true
                }
                else
                {
                return false
                }
            }
        else{
            return false
        }
    }
    
    func IsBoulder(row : Int, column : Int) -> Bool{
        if AnimtaedObjectTileType(row: row, column: column) == TileType.boulder ||
            AnimtaedObjectTileType(row: row, column: column) == TileType.boulder2 ||
            AnimtaedObjectTileType(row: row, column: column) == TileType.boulder3
            {
            return true
        }
        else{
            return false
        }
    }
    
    func IsFire(row : Int, column : Int) -> Bool{
        if(ObjectTileType(row: row, column: column) == TileType.fire_vertical ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_horizontal ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_end_top ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_end_bottom ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_end_left ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_end_right ||
            ObjectTileType(row: row, column: column) == TileType.fire_t_left ||
            ObjectTileType(row: row, column: column) == TileType.fire_t_right ||
            ObjectTileType(row: row, column: column) == TileType.fire_t_top ||
            ObjectTileType(row: row, column: column) == TileType.fire_t_bottom ||
            ObjectTileType(row: row, column: column) == TileType.fire_x ||
            ObjectTileType(row: row, column: column) ==  TileType.fire_bend_bottom_left ||
            ObjectTileType(row: row, column: column) == TileType.fire_bend_bottom_right ||
            ObjectTileType(row: row, column: column) == TileType.fire_bend_top_left ||
            ObjectTileType(row: row, column: column) == TileType.fire_bend_top_right){
            return true
        }
        else{
            return false
        }
    }
    
    func isSpike(row : Int, column : Int) -> Bool{
         if(ObjectTileType(row: row, column: column) == .spike1_top ||
            ObjectTileType(row: row, column: column) == .spike1_bottom ||
            ObjectTileType(row: row, column: column) == .spike1_left ||
            ObjectTileType(row: row, column: column) == .spike1_right){
                return true
        }
         else{
            return false
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func runChecker() {
        checker = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(self.updateChecker)), userInfo: nil, repeats: true)
    }
    
    func updateChecker(){
        
        spikeCount += 0.2
        if spikeCount > 2.0{
               spikeCount = 0
        }
        
        
        let currentColumn = landBackground.tileColumnIndex(fromPosition: wizard.position)
        let currentRow = landBackground.tileRowIndex(fromPosition: wizard.position)

        if let node = wizard.interruptNode{
            if currentColumn == node.column && currentRow == node.row{
                wizard.removeAllActions()
            }
        }
        
        for baddie in baddies{
            if let node = baddie.interruptNode{
                let baddieCurrentColumn = landBackground.tileColumnIndex(fromPosition: baddie.position)
                let baddieCurrentRow = landBackground.tileRowIndex(fromPosition: baddie.position)
                if baddieCurrentColumn == node.column && baddieCurrentRow == node.row{
                    baddie.removeAllActions()
                    startFollowingPath(character : baddie, path: enemyPathToNode(baddie: baddie))
                    baddie.doneMoving = false
                    baddie.interruptNode = nil
                }
            }
        }
        
        if winningTile != nil{
            if wizard.position == winningTile{
                let transition:SKTransition = SKTransition.fade(withDuration : 1)
                if let levelScene:GameScene = GameScene(fileNamed: "Level" + String(levelNumber + 1)){
                    levelScene.selectedWizardColour = selectedWizardColour
                    self.view?.presentScene(levelScene, transition: transition)
                    winningTile = nil
                }
            }
        }
        
        //check if wizard died by fire
        if IsFire(row: currentRow, column: currentColumn) && wizard.died == false{
            SetTile(tile: TileType.fire, row: currentRow, column: currentColumn, destroyedBoulder : false, destroyedCharacter : wizard)
            wizard.died = true
            wizard.removeAllActions()
            soundGenerator.run(SKAction.playSoundFileNamed("die.m4a", waitForCompletion: false))
        }
        
        //check if wizard died by spike
        if isSpike(row: currentRow, column: currentColumn) && wizard.died == false && spikeCount >= 1.2{
            SetTile(tile: TileType.fire, row: currentRow, column: currentColumn, destroyedBoulder : false, destroyedCharacter : wizard)
            wizard.died = true
            wizard.removeAllActions()
            soundGenerator.run(SKAction.playSoundFileNamed("die.m4a", waitForCompletion: false))
        }
        
        //check if wizard died by baddie
        for baddie in baddies{
            let baddieColumn = landBackground.tileColumnIndex(fromPosition: baddie.position)
            let baddieRow = landBackground.tileRowIndex(fromPosition: baddie.position)
            if currentColumn == baddieColumn && currentRow == baddieRow && wizard.died == false{
                SetTile(tile: TileType.fire, row: currentRow, column: currentColumn, destroyedBoulder : false, destroyedCharacter : wizard)
                wizard.died = true
                wizard.removeAllActions()
                soundGenerator.run(SKAction.playSoundFileNamed("die.m4a", waitForCompletion: false))
            }
        }
        
        if IsFire(row: currentRow, column: currentColumn) && wizard.died == false{
            SetTile(tile: TileType.fire, row: currentRow, column: currentColumn)
            wizard.died = true
            wizard.removeAllActions()
        }
        
        //check if baddie died
        var baddieToRemoveIndex : Int = 0
        var baddieDied : Bool = false
        for baddie in baddies{
            
            let baddieColumn = landBackground.tileColumnIndex(fromPosition: baddie.position)
            let baddieRow = landBackground.tileRowIndex(fromPosition: baddie.position)
            
            if IsFire(row: baddieRow, column: baddieColumn) && baddie.died == false{
                SetTile(tile: TileType.fire, row: baddieRow, column: baddieColumn,destroyedBoulder : false, destroyedCharacter: baddie)
                baddie.died = true
                baddie.removeAllActions()
                baddieToRemoveIndex = baddies.index(of: baddie)!
                baddieDied = true
            }
        }
        if baddieDied{
            baddies.remove(at: baddieToRemoveIndex)
        }
        
        
        if wizard.died == false
        {
            if let prize = prize(row: currentRow, column: currentColumn){
                if prize.type == TileType.ruby && !prize.collected{
                    soundGenerator.run(SKAction.playSoundFileNamed("prizeCollection.m4a", waitForCompletion: false))
                    score += 10
                    lblScore.text = String(score)
                    prize.collected = true
                    updateNumberOfBombs()
                }
                else if prize.type == TileType.emerald && !prize.collected{
                    soundGenerator.run(SKAction.playSoundFileNamed("prizeCollection.m4a", waitForCompletion: false))
                    score += 10
                    lblScore.text = String(score)
                    prize.collected = true
                    updateNumberOfBombs()
                }
                else if prize.type == TileType.life && !prize.collected{
                    soundGenerator.run(SKAction.playSoundFileNamed("prizeCollection.m4a", waitForCompletion: false))
                    wizard.lives += 1
                    lifeCount.text = "X " + String(wizard.lives)
                    prize.collected = true
                }
                else if prize.type == TileType.fireBulletsItem && !prize.collected{
                    soundGenerator.run(SKAction.playSoundFileNamed("prizeCollection.m4a", waitForCompletion: false))
                    currentItem.texture = SKTexture(imageNamed: "fireBulletsIcon")
                    prize.collected = true
                }
                
                SetTile(tile: TileType.empty, row: currentRow, column: currentColumn)
            }
            
           
        
        }
    }
    
    
    func updateNumberOfBombs(){
        var existingBombs = 0
        for bomb in bombsList{
            if bomb.removed == false{
                existingBombs += 1
            }
        }
        
        if score > 10{
            wizard.numberOfBombs = 2 - existingBombs
        }
        if score > 30{
            wizard.numberOfBombs = 3 - existingBombs
        }
        if score > 50{
            wizard.numberOfBombs = 4 - existingBombs
        }
        if existingBombs == 0 && score > 10{
             wizard.numberOfBombs = 1
        }
    }
    
    func spreadFire(row : Int, column : Int, direction : Direction) -> Bool{
        var stop : Bool = false
        var went : Bool = false
        var hitItem : Bool = false
        
        var columnToCheck = column
        var rowToCheck = row
        
        var tileCentre : TileType = .empty
        var tileEnd : TileType = .empty
        
        
        
        
        
        for tile in 1...3{
            
            if direction == .left{
                tileCentre = .fire_horizontal
                tileEnd = .fire_end_left
                columnToCheck = column - tile
            }
            if direction == .right{
                tileCentre = .fire_horizontal
                tileEnd = .fire_end_right
                columnToCheck = column + tile
            }
            if direction == .up{
                tileCentre = .fire_vertical
                tileEnd = .fire_end_top
                rowToCheck = row + tile
            }
            if direction == .down{
                tileCentre = .fire_vertical
                tileEnd = .fire_end_bottom
                rowToCheck = row - tile
            }
            
            if stop == false{
                if(IsOpenPassage(row: rowToCheck, column: columnToCheck) && stop == false){
                    if(tile < 3){
                        if(IsBoulder(row: rowToCheck, column: columnToCheck)){
                            SetTile(tile: tileEnd, row: rowToCheck, column: columnToCheck, destroyedBoulder: true)
                            went = true
                            stop = true
                            hitItem = true
                        }
                        else if(stop == false){
                            SetTile(tile: tileCentre, row: rowToCheck, column: columnToCheck)
                            went = true
                        }
                    }
                    else{
                        SetTile(tile: tileEnd, row: rowToCheck, column: columnToCheck)
                        went = true
                    }
                }
                else if tile == 1{
                    stop = true
                }
                else{
                    if(went && hitItem == false){
                        if direction == .up{
                            SetTile(tile: tileEnd, row: rowToCheck - 1, column: columnToCheck)
                        }
                        else if direction == .down{
                            SetTile(tile: tileEnd, row: rowToCheck + 1, column: columnToCheck)
                        }
                        else if direction == .left{
                            SetTile(tile: tileEnd, row: rowToCheck, column: columnToCheck + 1)
                        }
                        else if direction == .right{
                            SetTile(tile: tileEnd, row: rowToCheck, column: columnToCheck - 1)
                        }
                        
                    }
                    stop = true
                }
            }
        }
        return went
    }
    
    func updateTimer() {
        
        if baddies.count == 0{
            wonLevel()
        }
        
        for baddie in baddies{
            
            let randomNum:UInt32 = arc4random_uniform(5)
            let someInt:Int = Int(randomNum)
            if someInt == 1{
                if baddie.type == .grub {
                    soundGenerator.run(SKAction.playSoundFileNamed("grubSound.m4a", waitForCompletion: false))
                }
                else if baddie.type == .blueEyedFrog {
                    soundGenerator.run(SKAction.playSoundFileNamed("blueEyedFrogSqueal.m4a", waitForCompletion: false))
                }
                
            }
            
            if baddie.doneMoving{
                startFollowingPath(character : baddie, path: enemyPathToNode(baddie: baddie))
                baddie.doneMoving = false
            }
            
        }
        
        
        for fire in fireList{
            if(fire.time > 0){
                fire.time -= 1
            }
            if(fire.time == 0 && fire.removed == false && fire.destroyedCharacter == nil){//bomb blows up
                
                var tile : TileType = TileType.empty
                if fire.destroyedBoulder{
                    let randomNum:UInt32 = arc4random_uniform(5)
                    let someInt:Int = Int(randomNum)
                    switch someInt{
                    case 1:
                        tile = TileType.ruby
                        AddPrize(row: fire.row, column: fire.column, type: tile)
                    case 2:
                        tile = TileType.emerald
                        AddPrize(row: fire.row, column: fire.column, type: tile)
                    case 3:
                        tile = TileType.life
                        AddPrize(row: fire.row, column: fire.column, type: tile)
                    case 4:
                        return
                    case 5:
                        tile = TileType.fireBulletsItem
                        AddPrize(row: fire.row, column: fire.column, type: tile)
                    default:
                        tile = TileType.empty
                    }
                }
                SetTile(tile: tile, row: fire.row, column: fire.column)
                fire.removed = true
            }
            else if(fire.time == 0 && fire.destroyedCharacter != nil && fire.removed == false){
                guard let tileSet = SKTileSet(named: "Sample Grid Tile Set") else {
                    fatalError("Object Tiles Tile Set not found")
                }
                let tileGroups = tileSet.tileGroups
                var tile : TileType = TileType.empty
                let tileToSet = tileGroups.first(where: {$0.name == tile.description})
                effectsMap.setTileGroup(tileToSet, forColumn: fire.column, row: fire.row)
                fire.removed = true
                
                if fire.destroyedCharacter == wizard{
                    wizard.died = false
                    wizard.lives -= 1
                    lifeCount.text = "X " + String(wizard.lives)
                    if wizard.lives == 0{
                        gameOver.position = CGPoint(x: 0, y: 0)
                        wizard.removeFromParent()
                    }
                    else{
                        wizard.position = startingPosition
                        targetLocation = startingPosition
                    }
                }
                else{
                    fire.destroyedCharacter?.removeFromParent()
                }
               
            }
        }
        
        for bomb in bombsList{
            if(bomb.time > 0){
                bomb.time -= 1
            }
            
            if(bomb.time == 0 && bomb.removed == false){//bomb blows up
                setGraph()
                wizard.numberOfBombs += 1
                soundGenerator.run(SKAction.playSoundFileNamed("explosion.m4a", waitForCompletion: false))
                bomb.removed = true
                 SetTile(tile: TileType.empty, row: bomb.row, column: bomb.column)
                
                var wentLeft : Bool = spreadFire(row: bomb.row, column: bomb.column, direction: Direction.left)
                var wentRight : Bool = spreadFire(row: bomb.row, column: bomb.column, direction: Direction.right)
                var wentUp : Bool = spreadFire(row: bomb.row, column: bomb.column, direction: Direction.up)
                var wentDown : Bool = spreadFire(row: bomb.row, column: bomb.column, direction: Direction.down)
                
              
                if(wentLeft && wentDown && wentUp == false || wentRight && wentDown && wentUp == false){
                    SetTile(tile: TileType.fire_t_bottom, row: bomb.row, column: bomb.column)
                }
                if(wentLeft && wentUp && wentDown == false || wentRight && wentUp && wentDown == false){
                     SetTile(tile: TileType.fire_t_top, row: bomb.row, column: bomb.column)
                }
                
                if(wentUp && wentLeft && wentRight == false || wentDown && wentLeft  && wentRight == false){
                    SetTile(tile: TileType.fire_t_left, row: bomb.row, column: bomb.column)
                }
                if(wentUp && wentLeft == false && wentRight || wentDown && wentLeft == false && wentRight ){
                    SetTile(tile: TileType.fire_t_right, row: bomb.row, column: bomb.column)
                }
                
                if(wentLeft && wentUp && wentDown && wentRight){
                    SetTile(tile: TileType.fire_x, row: bomb.row, column: bomb.column)
                }
                
                if(wentLeft && wentRight && wentUp == false && wentDown == false){
                    SetTile(tile: TileType.fire_horizontal, row: bomb.row, column: bomb.column)
                }
                
                if(wentLeft == false && wentRight == true && wentUp == true && wentDown == false){
                    SetTile(tile: TileType.fire_bend_bottom_left, row: bomb.row, column: bomb.column)
                }
                
                if(wentLeft == false && wentRight == true && wentUp == false && wentDown == true){
                    SetTile(tile: TileType.fire_bend_top_left, row: bomb.row, column: bomb.column)
                }
                
                if(wentLeft == true && wentRight == false && wentUp == false && wentDown == true){
                    SetTile(tile: TileType.fire_bend_top_right, row: bomb.row, column: bomb.column)
                }
                
                if(wentLeft == true && wentRight == false && wentUp == true && wentDown == false){
                    SetTile(tile: TileType.fire_bend_bottom_right, row: bomb.row, column: bomb.column)
                }
                
                if(wentLeft == false && wentRight == false && wentUp  && wentDown ){
                    SetTile(tile: TileType.fire_vertical, row: bomb.row, column: bomb.column)
                }
                
            }
        }
        
    }
    
  
  
    func touchDown(atpoint pos: CGPoint){
        let column = landBackground.tileColumnIndex(fromPosition: pos)
        let row = landBackground.tileRowIndex(fromPosition: pos)
        print(column)
        print(row)
        if let tileBackground:SKTileDefinition? = landBackground.tileDefinition(atColumn: column, row: row){
            if let tileObjects:SKTileDefinition? = objectsMap.tileDefinition(atColumn: column, row: row){
                if tileBackground != nil && tileObjects?.name != TileType.boulder.description{
                    
                    targetLocation = CGPoint(x: pos.x, y: pos.y)
                    if !wizard.died{
                         startFollowingPath(character : wizard, path: pathToNode())
                    }
                }
            }
        }
    }
    
    
    func pathToNode()->[GKGridGraphNode]{
        
        let startX = landBackground.tileColumnIndex(fromPosition: wizard.position)
        let startY = landBackground.tileRowIndex(fromPosition: wizard.position)
        
        let endX = landBackground.tileColumnIndex(fromPosition: targetLocation)
        let endY = landBackground.tileRowIndex(fromPosition: targetLocation)
        
        var startNode : GKGridGraphNode!
        var endNode  : GKGridGraphNode!
        if newBomb == true{
            if let start = graphBeforeBomb.node(atGridPosition: int2(Int32(startX), Int32(startY))){
                startNode = start
            }
            else{
                wizard.path = nil
                return [GKGridGraphNode]()
            }
            endNode = graphBeforeBomb.node(atGridPosition: int2(Int32(endX), Int32(endY)))
            newBomb = false
        }
        else{
            if let start = graph.node(atGridPosition: int2(Int32(startX), Int32(startY))){
                startNode = start
            }
            else{
                wizard.path = nil
                return [GKGridGraphNode]()
            }
             endNode = graph.node(atGridPosition: int2(Int32(endX), Int32(endY)))
        }
        if let end = endNode{
        
        let path : [GKGridGraphNode] = graph.findPath(from: startNode, to: end) as! [GKGridGraphNode]
            
        wizard.path = [coordinates]()
            
        for node: GKGridGraphNode in path {
                let x = Int(node.gridPosition.x)
                let y = Int(node.gridPosition.y)
                let coord = coordinates()
                coord.row = y
                coord.column = x
                wizard.path.append(coord)
            }
            return path
        }
        else{
            wizard.path = nil
            return [GKGridGraphNode]()
        }
    }
    
    
    func enemyPathToNode(baddie : Baddie)->[GKGridGraphNode]{
        
        let startX = landBackground.tileColumnIndex(fromPosition: baddie.position)
        let startY = landBackground.tileRowIndex(fromPosition: baddie.position)
        
        if let startNode = graph.node(atGridPosition: int2(Int32(startX), Int32(startY))){
            if graph != nil{
                var paths : [[GKGridGraphNode]] = [[GKGridGraphNode]]()
                var numberOfNodes : [Int] = [Int]()
                
                for column in 0..<landBackground.numberOfColumns
                {
                    for row in 0..<landBackground.numberOfRows
                    {
                        if let endNode = graph.node(atGridPosition: vector_int2(Int32(column),Int32(row))){
                            let path : [GKGridGraphNode] = graph.findPath(from: startNode, to: endNode) as! [GKGridGraphNode]
                            if path.count > 0{
                                numberOfNodes.append(path.count)
                                paths.append(path)
                            }
                        }
                    }
                }
                
                if let highestIndex = numberOfNodes.index(of: numberOfNodes.max()!){
                    
                    baddie.path = [coordinates]()
                    
                    for node: GKGridGraphNode in paths[highestIndex] {
                        let x = Int(node.gridPosition.x)
                        let y = Int(node.gridPosition.y)
                        let coord = coordinates()
                        coord.row = y
                        coord.column = x
                        baddie.path.append(coord)
                    }
                    return paths[highestIndex]
                }
                else{
                     baddie.path = nil
                    return [GKGridGraphNode]()
                }
            }
            else{
                baddie.path = nil
                return [GKGridGraphNode]()
            }
        }
        else{
            baddie.path = nil
            return [GKGridGraphNode]()
        }
       
        
    }
    
    func startFollowingPath(character : CharacterBase, path : [GKGridGraphNode]){
        if path.count > 0{
            var path = path
            path.remove(at: 0)
            var actions = [SKAction]()
              character.removeAllActions()
                for node: GKGridGraphNode in path {
                    let x = Int(node.gridPosition.x)
                    let y = Int(node.gridPosition.y)
                    let location : CGPoint = landBackground.centerOfTile(atColumn: x, row: y)
                    let point = CGPoint(x: CGFloat(roundToTileSize(Double(location.x))), y: CGFloat(roundToTileSize(Double(location.y))))
                   
                    let action = SKAction.move(to: point, duration: character.moveSpeed)
                    var animationAction : SKAction!
                    var previousPoint : CGPoint!
                    if node == path.first{
                        previousPoint  = character.position
                    }
                    else{
                        let index = path.index(of: node)
                        let nd = path[index! - 1]
                        let xNd = Int(nd.gridPosition.x)
                        let yNd = Int(nd.gridPosition.y)
                        previousPoint = landBackground.centerOfTile(atColumn: xNd, row: yNd)
                    }
                    if  previousPoint.x - point.x > 0{
                        animationAction = character.animationAction(direction: Direction.left)
                        if node == path.last{
                            character.lastDirection = .left
                        }
                    }
                    if previousPoint.x - point.x < 0{
                        animationAction = character.animationAction(direction: Direction.right)
                        if node == path.last{
                            character.lastDirection = .right
                        }
                    }
                    if previousPoint.y - point.y > 0{
                        animationAction = character.animationAction(direction: Direction.down)
                        if node == path.last{
                            character.lastDirection = .down
                        }
                    }
                    if previousPoint.y - point.y < 0{
                        animationAction = character.animationAction(direction: Direction.up)
                        if node == path.last{
                            character.lastDirection = .up
                        }
                    }
                    let group = SKAction.group([action, animationAction])
                    actions.append(group)
                }
                let sequence = SKAction.sequence(actions)
            character.run(sequence, completion: {
                if character.AI{
                    //reset path
                    character.doneMoving = true
                }
            })
        }
    }
    
    func roundToTileSize(_ x : Double) -> Int {
        return Int(landBackground.tileSize.height) * Int((x / Double(landBackground.tileSize.height)).rounded())
    }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    for t in touches{
        touchDown(atpoint: t.location(in: sceneFrame))
    }
    
  }
    
    func navigateToScene(name : String){
        
        let transition:SKTransition = SKTransition.fade(withDuration : 1)
        if let scene:GameScene = GameScene(fileNamed: name){
            scene.selectedWizardColour = selectedWizardColour
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: sceneFrame)
        let touchLocationMenu = touch!.location(in: menu)
        // Check if the location of the touch is within the button's bounds
        if menuButton.contains(touchLocation) {
            menu.position = CGPoint(x: 0, y: 0)
            soundGenerator.run(SKAction.playSoundFileNamed("pause.m4a", waitForCompletion: true))
            self.isPaused = true
        }
        if closeButton.contains(touchLocationMenu) {
            menu.position = CGPoint(x: 1000, y: 0)
            soundGenerator.run(SKAction.playSoundFileNamed("pause.m4a", waitForCompletion: false))
            self.isPaused = false
        }
        if quitButton.contains(touchLocationMenu) {
            //go to level selector
            navigateToScene(name: "LevelSelector")
        }
    }
  
   
    func prize(row : Int, column : Int)-> Prize?{
        for prize in prizeList{
            if prize.row == row && prize.column == column && prize.collected == false
            {
                return prize
            }
        }
        return nil
    }
  
  override func update(_ currentTime: TimeInterval) {
  }
    
  override func didSimulatePhysics() {
  }
}
