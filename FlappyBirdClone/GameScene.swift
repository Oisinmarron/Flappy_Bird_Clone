//
//  GameScene.swift
//  FlappyBirdClone
//
//  Created by Oisin Marron on 24/11/2020.
//  Copyright © 2020 Oisin Marron. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory{
    static let Character : UInt32 = 0x1 << 1
    static let Floor : UInt32 = 0x1 << 2
    static let Pillar : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Character = SKSpriteNode()
    var Grass = [SKSpriteNode]()
    var Test = SKSpriteNode()
    var Rock = SKSpriteNode()
    
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var died = Bool()
    
    var score = Int()

    var restartBtn = SKSpriteNode()
    let scoreLabel = SKLabelNode()
    
    
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        score = 0
        gameStarted = false
        
        createScene()
    }
    
    func createScene(){
        
        // print(UIFont.familyNames)
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2{
            let background = SKSpriteNode(imageNamed: "Background")
            //background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "Background"
            background.size = CGSize(width: self.frame.width, height: self.frame.height)
            self.addChild(background)
        }
        
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height/4)
        scoreLabel.text = "\(score)"
        scoreLabel.fontName = "04b_19"
        scoreLabel.fontSize = 150
        scoreLabel.zPosition = 5
        
        self.addChild(scoreLabel)
        
        // GRASS
        Test = SKSpriteNode(imageNamed: "Grass")
        Test.setScale(2)
        
        let tileNum = Int(ceil((self.frame.width / Test.frame.width) + 1))
        var count = 0
        let Floor = SKNode()
        
        repeat{
        
            Grass.append(SKSpriteNode(imageNamed: "Grass"))
            Grass[count].setScale(2)
            
            Grass[count].position = CGPoint(x: (CGFloat(count)*Grass[count].frame.width)-self.frame.width/2,  y: Grass[count].frame.height - self.frame.height/2)
         
            Grass[count].physicsBody = SKPhysicsBody(rectangleOf: Grass[count].size)
            Grass[count].physicsBody?.categoryBitMask = PhysicsCategory.Floor
            Grass[count].physicsBody?.collisionBitMask = PhysicsCategory.Character
            Grass[count].physicsBody?.contactTestBitMask = PhysicsCategory.Character
            Grass[count].physicsBody?.affectedByGravity = false
            Grass[count].physicsBody?.isDynamic = false
         
            Floor.addChild(Grass[count])
         
            count+=1
            
        }while(count < tileNum)
        
        Floor.zPosition = 3
        
        self.addChild(Floor)
        
        
        // GRAVEL
        count = 0
        
        repeat{
        
            Rock = SKSpriteNode(imageNamed: "Rock")
            Rock.setScale(2)
            
            Rock.position = CGPoint(x: (CGFloat(count)*Rock.frame.width)-self.frame.width/2,  y: -self.frame.height/2)
         
            Rock.zPosition = 4
            self.addChild(Rock)
            count+=1
            
        }while(count < tileNum)
        
        
        // CHARACTER
        Character = SKSpriteNode(imageNamed: "Fly")
        Character.size = CGSize(width: 200, height: 130)
        Character.position = CGPoint(x: 0 - self.frame.width/4, y: 0)
        
        Character.physicsBody = SKPhysicsBody(rectangleOf: Character.size)
        Character.physicsBody?.categoryBitMask = PhysicsCategory.Character
        Character.physicsBody?.collisionBitMask = PhysicsCategory.Floor | PhysicsCategory.Pillar
        Character.physicsBody?.contactTestBitMask = PhysicsCategory.Floor | PhysicsCategory.Pillar | PhysicsCategory.Score
        Character.physicsBody?.affectedByGravity = false
        Character.physicsBody?.isDynamic = true
        
        Character.zPosition = 1
        
        self.addChild(Character)
        
    }
    
    override func didMove(to view: SKView) {
        
        createScene()
    
    }
    
    func createBtn(){
            
        restartBtn = SKSpriteNode(imageNamed: "Play")
        
        restartBtn.setScale(0)
        restartBtn.size = CGSize(width: self.frame.width * 0.2, height: self.frame.height * 0.1)
        
        restartBtn.position = CGPoint(x: 0, y: 0)
        restartBtn.zPosition = 6
        
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1, duration: 0.3))
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if (firstBody.categoryBitMask == PhysicsCategory.Score && secondBody.categoryBitMask == PhysicsCategory.Character) || (firstBody.categoryBitMask == PhysicsCategory.Character && secondBody.categoryBitMask == PhysicsCategory.Score) {
            
            score+=1
            scoreLabel.text = "\(score)"
        }
        
        else if (firstBody.categoryBitMask == PhysicsCategory.Pillar && secondBody.categoryBitMask == PhysicsCategory.Character) || (firstBody.categoryBitMask == PhysicsCategory.Character && secondBody.categoryBitMask == PhysicsCategory.Pillar) {
            
            // Stops pillars moving, also stops all actions (i.e. creating pillars)
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
            }))
            
            if died == false{
                died = true
                let moveTexture = SKTexture(imageNamed: "Dead")
                Character.texture = moveTexture
                createBtn()
            }
        }
        
        else if (firstBody.categoryBitMask == PhysicsCategory.Floor && secondBody.categoryBitMask == PhysicsCategory.Character) || (firstBody.categoryBitMask == PhysicsCategory.Character && secondBody.categoryBitMask == PhysicsCategory.Floor) {
            
            // Stops pillars moving, also stops all actions (i.e. creating pillars)
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
            }))
            
            if died == false{
                died = true
                let moveTexture = SKTexture(imageNamed: "Dead")
                Character.texture = moveTexture
                createBtn()
            }
        }
    }
    
    func createWalls(){
        
        let scoreNode = SKSpriteNode()
        
        scoreNode.size = CGSize(width: 3, height: Character.size.height * 2.5)
        scoreNode.position = CGPoint(x: self.frame.width, y: 0)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.Character
        // scoreNode.color = SKColor.blue
        
        let randomPosition = CGFloat.random(min: -self.frame.height/5, max: self.frame.height/5)
        
        scoreNode.position.y = scoreNode.position.y + randomPosition
        
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "Pillar")
        let btmWall = SKSpriteNode(imageNamed: "Pillar")
        
        
        topWall.setScale(0.75)
        btmWall.setScale(0.75)
        
        topWall.position = CGPoint(x: self.frame.width, y: topWall.size.height/2 + Character.size.height * 1.15)
        
        btmWall.position = CGPoint(x: self.frame.width, y: -btmWall.size.height/2 - Character.size.height * 1.15)
        
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.Pillar
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.Character
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.Character
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCategory.Pillar
        btmWall.physicsBody?.collisionBitMask = PhysicsCategory.Character
        btmWall.physicsBody?.contactTestBitMask = PhysicsCategory.Character
        btmWall.physicsBody?.affectedByGravity = false
        btmWall.physicsBody?.isDynamic = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        topWall.position.y = topWall.position.y + randomPosition
        btmWall.position.y = btmWall.position.y + randomPosition
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 2
        
        wallPair.addChild(scoreNode)
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if gameStarted == false{
            
            gameStarted = true
            
            Character.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run({
                () in
                
                self.createWalls()
                
            })
            
            let delay = SKAction.wait(forDuration: 2.5)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(2 * self.frame.width)
            let movePillars = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.005 * distance))
            let removePillars = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
            
            Character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        }
        else{
            if died == true{
                // Do nothing
            }
            else{
                Character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                Character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
            }
        }
        
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if died == true{
                if restartBtn.contains(location){
                    restartScene()
                }
            }
        }
    }
        
 
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if gameStarted == true && died == false{
            enumerateChildNodes(withName: "Background", using: ({
                (node, error) in
                
                let background = node as! SKSpriteNode
                background.position = CGPoint(x: background.position.x - 2, y: background.position.y)
                
                // If background runs out, starts it again
                if background.position.x <= -background.size.width{
                    background.position = CGPoint(x: background.position.x + background.size.width * 2, y: background.position.y)
                }
            }))
        }
    }
}
