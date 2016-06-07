//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Tugce Tekerlekci on 4/24/16.
//  Copyright (c) 2016 Tugce Tekerlekci. All rights reserved.
//

import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    
    var bg=SKSpriteNode()
    
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    
    var movingObjects = SKSpriteNode()
    
    var labelContainer = SKSpriteNode()
    
    var score = 0
    
    var scoreLabel = SKLabelNode()
    
    var gameOverLabel = SKLabelNode()
    
    
    
    //enum a way of categorizing different types of objects. 
    //bird collide with an object then game over. 
    
    enum ColliderType: UInt32 {
        
        case Bird = 1
        
        case Object = 2
        
        case Gap = 4
    
    
    
    }
    
    var gameOver = false
    
    func makebg()
    {
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        
        let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        
        let replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        
        let movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg,replacebg]))
        
        
        
        
        
        for var i:CGFloat = 0; i<3 ; i++
        {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            
            bg.zPosition = 1
            
            
            bg.size.height = self.frame.height
            
            bg.runAction(movebgForever)
            
            
            movingObjects.addChild(bg)
            
            
        }
    
    
    }
    
    
    
    override func didMoveToView(view: SKView) {
        
        
       
        
        
        self.physicsWorld.contactDelegate = self
        
        
        self.addChild(movingObjects)
        
        self.addChild(labelContainer)
        
        makebg()
        
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        scoreLabel.zPosition = 3
        self.addChild(scoreLabel)
        
        
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animateWithTextures([birdTexture,birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.zPosition = 3
        
        bird.runAction(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        bird.physicsBody?.dynamic = true
        
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        

        self.addChild(bird)
        
        var ground = SKNode()
        ground.zPosition = 2
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize:  CGSizeMake(frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        
        
        
        
        ground.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        
        
        
        self.addChild(ground)
        
        
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
     
       
    }
    
    func makePipes()
    {
        
        let gapHeight = bird.size.height * 4
        
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height/2) // random betwe 0 and 1.
        
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4 ;
        
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
        
        let removePipes = SKAction.removeFromParent()
        
        let moveAndRemovePipes = SKAction.sequence([movePipes,removePipes])
        
        
        
        var pipeTexture = SKTexture(imageNamed: "pipe1.png")
        
        var pipe1 = SKSpriteNode(texture: pipeTexture)
        
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeTexture.size().height/2 + gapHeight/2 + pipeOffset)
        pipe1.zPosition = 2
        
        
        
        
        pipe1.runAction(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture.size())
        pipe1.physicsBody!.dynamic = false
        
        pipe1.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        

        
        movingObjects.addChild(pipe1)
        
        
        var pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        
        var pipe2 = SKSpriteNode(texture: pipe2Texture)
        
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width , y: CGRectGetMidY(self.frame) - pipe2Texture.size().height/2 - gapHeight/2 + pipeOffset)
        
        pipe2.zPosition = 3
        
        
        pipe2.runAction(moveAndRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture.size())
        pipe2.physicsBody!.dynamic = false
        
        
        pipe2.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        movingObjects.addChild(pipe2)
        
        var gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width , y: CGRectGetMidY(self.frame)+pipeOffset)
        gap.zPosition = 5
        gap.runAction(moveAndRemovePipes)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight))
        gap.physicsBody!.dynamic = false
        
        gap.physicsBody?.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody?.collisionBitMask = ColliderType.Gap.rawValue
        
        movingObjects.addChild(gap)
        
        
        
  
    
    }
    
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        
        
        if (contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue)
        {
            score++
            scoreLabel.text = String(score)
        
        
        }
        
        
     
        else
        {
               if gameOver == false
            
               {
        
                    gameOver = true
            
                    self.speed = 0
            
                    //gameOverLabel.fontName = "Helvetica"
                    gameOverLabel.fontSize = 30
                    gameOverLabel.color = UIColor.blackColor()
                    print(score)
                    gameOverLabel.text = "Game Over! Tap to play again!"
                    gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                    gameOverLabel.zPosition = 9
                    labelContainer.addChild(gameOverLabel)
                
                }
            
            else
               {
                    score = 0
                    scoreLabel.text = "0"
                    bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                    bird.physicsBody!.velocity = CGVectorMake(0, 0)
                    movingObjects.removeAllChildren()
                    makebg()
                
                    self.speed = 1
                
                    gameOver = false
                
                    labelContainer.removeAllChildren()
                
                
                
                
            
            }
        
        }
    
        
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        if gameOver == false
        
        {
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
        
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
    
        }
        
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
