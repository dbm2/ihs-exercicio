//
//  GameScene.swift
//  SpacegameReloaded
//
//  Created by Training on 01/10/2016.
//  Copyright © 2016 Training. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, GameSceneProtocol, SKPhysicsContactDelegate {
    
    weak var gameDelegate: GameSceneDelegate?
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!

    var possibleAliens = ["alien", "alien2", "alien3"]
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            self.gameDelegate?.didChange(score: self.score)
        }
    }
    
    var gameTimer: Timer!

    let enemyCategory: UInt32 = 0x1 << 1
    let photonTorpedoCategory: UInt32 = 0x1 << 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.starfield = SKEmitterNode(fileNamed: "Starfield")
        self.starfield.position = CGPoint(x: 0.0, y: self.frame.height)
        self.starfield.advanceSimulationTime(10.0)
        self.addChild(self.starfield)
        self.starfield.zPosition = -1
        
        self.player = SKSpriteNode(imageNamed: "shuttle")
        self.player.position = CGPoint(x: self.frame.width/2.0, y: player.size.height + 40.0)
        self.addChild(self.player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        self.scoreLabel = SKLabelNode(text: "Score: 0")
        self.scoreLabel.position = CGPoint(x: 80, y: self.frame.size.height - 60)
        self.scoreLabel.fontName = "Digital-7Mono"
        self.scoreLabel.fontSize = 36
        self.scoreLabel.fontColor = UIColor.white
        self.addChild(scoreLabel)
        self.scoreLabel.zPosition = 1
        
        self.gameTimer = Timer.scheduledTimer(timeInterval: 0.75,
                                              target: self,
                                              selector: #selector(addAlien),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc func addAlien () {
        let randomEnemyIndex: Int = GKRandomDistribution(lowestValue: 0, highestValue: possibleAliens.count-1).nextInt()
        
        let enemy: SKSpriteNode = SKSpriteNode(imageNamed: self.possibleAliens[randomEnemyIndex])
        
        let enemyRandomX: Int = GKRandomDistribution(lowestValue: Int(enemy.size.width/2),
                                                     highestValue: Int(self.frame.width - enemy.size.width/2)).nextInt()
        
        enemy.position = CGPoint(x: CGFloat(enemyRandomX), y: self.frame.height + enemy.size.height)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = self.enemyCategory
        enemy.physicsBody?.contactTestBitMask = self.photonTorpedoCategory
        enemy.physicsBody?.contactTestBitMask = 0
        self.addChild(enemy)
        
        var actions: [SKAction] = []
        actions.append(SKAction.move(to: CGPoint(x: CGFloat(enemyRandomX), y: -enemy.size.height), duration: 6.0))
        actions.append(SKAction.removeFromParent())
        
        enemy.run(SKAction.sequence(actions))
    }
    
    func movePlayerLeft() {
        self.player.position.x -= 5.0
        if self.player.position.x < -20 {
            self.player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }
    }
    
    func movePlayerRight() {
        self.player.position.x += 5.0
        if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
    func fireTorpedo() {
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
    
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = self.photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = self.enemyCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: 0.3))
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & enemyCategory) != 0 {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    func torpedoDidCollideWithAlien (torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        self.score += 5
    }
}
