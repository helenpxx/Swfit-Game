 //
//  GameScene.swift
//  FlyingPig Marathon
//
//  Created by Helen Peng on 5/18/17.
//  Copyright © 2017 Helen Peng. All rights reserved.
//

import SpriteKit
import GameplayKit

var totalTime = 0
var timer : Timer!
var timing : Timer!
class GameScene: SKScene,SKPhysicsContactDelegate {
    private var label : SKLabelNode?
    var flyingPig:SKSpriteNode!
    var water = SKSpriteNode()
    var scoreLabel :SKLabelNode!
    
    var currentGameState = gameState.atGame

    struct PhysicsCategories{
        static let None :UInt32 = 0
        static let pig : UInt32 = 0b1
        static let aFish : UInt32 = 0b100
    }
    
    var fish = ["nemo","bluedy","lantern","balloon","Knife"]
    var myTime = 0
    var lives:[SKSpriteNode]!
    
    override func didMove(to view: SKView) {
        
        totalTime = 0
        self.physicsWorld.contactDelegate = self
        water = SKSpriteNode(imageNamed: "water")
        
        water.position = CGPoint(x: self.size.width/2,y:self.size.height/2)
        
        water.physicsBody = SKPhysicsBody(rectangleOf: water.size)
       
        water.physicsBody?.affectedByGravity = false
        water.physicsBody?.isDynamic = false
        
        self.addChild(water)
        
        flyingPig = SKSpriteNode(imageNamed:"FlyingPig")
        flyingPig.position = CGPoint(x:self.size.width/2,y:self.size.height/2)
        flyingPig.physicsBody = SKPhysicsBody(rectangleOf: flyingPig.size)
        flyingPig.physicsBody!.affectedByGravity=false
        flyingPig.physicsBody!.collisionBitMask = PhysicsCategories.None
        flyingPig.physicsBody!.categoryBitMask = PhysicsCategories.pig
        flyingPig.physicsBody!.contactTestBitMask = PhysicsCategories.aFish
        self.addChild(flyingPig)
        
        self.physicsWorld.gravity = CGVector(dx:0,dy:0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text:"Score: 0")
        scoreLabel.position = CGPoint(x:85,y:1270)
        scoreLabel.fontName = "PartyLetPlain"
        scoreLabel.fontSize = 44
        scoreLabel.text = "Score: \(totalTime) km"
        
        
        timer = Timer.scheduledTimer(timeInterval:1.35 ,target:self,selector:#selector(addFish),userInfo:nil,repeats:true)
        
        timing = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
      
        addLives()
    }
    

    func addLives()
    {
        lives = [SKSpriteNode()]
        for live in 1...3{
            let liveNode = SKSpriteNode(imageNamed:"FlyingPig2")
            liveNode.position = CGPoint(x:750-CGFloat(4-live)*liveNode.size.width,y:1270)
           
            lives.append(liveNode)
        }
    }
   
    @objc func addFish()
    {
        fish = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: fish) as![String]
        
        let aFish = SKSpriteNode(imageNamed: fish[0])
        
        let fishPosition = GKRandomDistribution(lowestValue:0, highestValue:700)
        let position = CGFloat(fishPosition.nextInt())
        aFish.position=CGPoint(x:position,y:1200)
        
        aFish.physicsBody = SKPhysicsBody(rectangleOf: aFish.size)
        aFish.physicsBody!.affectedByGravity = false
        aFish.physicsBody?.isDynamic=false
        aFish.physicsBody!.categoryBitMask = PhysicsCategories.aFish
        aFish.physicsBody!.collisionBitMask = PhysicsCategories.None
        aFish.physicsBody!.contactTestBitMask = PhysicsCategories.pig
        self.addChild(aFish)
        
       
        
        let animationDuration:TimeInterval = 12
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to:CGPoint(x:position,y:-800),duration:animationDuration))
        aFish.run(SKAction.sequence(actionArray))
            }
 
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.pig && body2.categoryBitMask==PhysicsCategories.aFish
        {
            body2.node?.removeFromParent()
            gameOver()
        }
    }
    
    enum gameState{
        case before
        case atGame
        case after
    }
    
    
    func gameOver(){
        self.removeAllActions()
        currentGameState=gameState.after
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration:0.1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene,changeSceneAction])
        self.run(changeSceneSequence)
    
        
        
    }
    func changeScene(){
        let newScene = GameOverScene(size:self.size)
        newScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.1)
        self.view!.presentScene(newScene,transition:transition )

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
      
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    
    }
    
    func touchUp(atPoint pos : CGPoint) {
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
       
        for touch in (touches ){
        let location = touch.location(in: self)
        if self.flyingPig.contains(location){
            flyingPig.position = location
            }
        }
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches ){
            let location = touch.location(in: self)
            if flyingPig.contains(location){
                flyingPig.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
           }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
   
    
    @objc func tick()
    {
        totalTime += 1
            }
}
