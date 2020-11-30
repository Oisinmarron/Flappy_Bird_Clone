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
}

class GameScene: SKScene {
    /*
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    */
    
    var Character = SKSpriteNode()
    var Grass = [SKSpriteNode]()
    var Test = SKSpriteNode()
    
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    // var Jump = SKSpriteNode()

    
    override func didMove(to view: SKView) {
        
        Test = SKSpriteNode(imageNamed: "Grass")
        Test.setScale(2)
        
        let tileNum = Int(ceil((self.frame.width / Test.frame.width) + 1))
        var count = 0
        let Floor = SKNode()
        //print(self.frame.height)
        // print(self.frame.width)
        
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
        
        
        Character = SKSpriteNode(imageNamed: "Character")
        Character.size = CGSize(width: self.frame.width/2 * 0.3, height: self.frame.height/2 * 0.25)
        Character.position = CGPoint(x: 0 - self.frame.width/4, y: Floor.frame.height + Character.frame.height - self.frame.height/2)
        
        Character.physicsBody = SKPhysicsBody(rectangleOf: Character.size)
        Character.physicsBody?.categoryBitMask = PhysicsCategory.Character
        Character.physicsBody?.collisionBitMask = PhysicsCategory.Floor | PhysicsCategory.Pillar
        Character.physicsBody?.contactTestBitMask = PhysicsCategory.Floor | PhysicsCategory.Pillar
        Character.physicsBody?.affectedByGravity = true
        Character.physicsBody?.isDynamic = true
        
        Character.zPosition = 2
        
        self.addChild(Character)
    
    }
    
    
    
    func createWalls(){
        /*
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        */
        wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "Pillar")
        let btmWall = SKSpriteNode(imageNamed: "Pillar")
        /*
        let topWall = SKSpriteNode(imageNamed: "PillarTop")
        let btmWall = SKSpriteNode(imageNamed: "PillarBtm")
        */
        
        topWall.position = CGPoint(x: self.frame.width/2, y: 0 + self.frame.height/4 + 80)
        btmWall.position = CGPoint(x: self.frame.width/2, y: 0 - self.frame.height/4 - 25)
        
        topWall.setScale(5)
        btmWall.setScale(5)
        
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
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        self.addChild(wallPair)
    }
    
    /*
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if gameStarted == false{
            
            gameStarted = true
        
            let spawn = SKAction.run({
                () in
                
                self.createWalls()
            })
            
            let delay = SKAction.wait(forDuration: 2.0)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width/2 + wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.0015 * distance))
            let removePillars = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
        
            Character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 400))
        }
        else{
            Character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 400))
            print("touch begin")
            super.touchesBegan(touches, with: event)
        }
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        print("touch ended")
        super.touchesEnded(touches, with: event)
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
/*
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
*/
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
