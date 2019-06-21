//
//  StartMenu.swift
//  FlyingPig Marathon
//
//  Created by Helen Peng on 5/17/17.
//  Copyright © 2017 Helen Peng. All rights reserved.
//

import SpriteKit

class StartMenu: SKScene {

    var startGame: SKSpriteNode!
    var gameName: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        gameName = self.childNode(withName:"gameName") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at:location)
            
            if nodesArray.first?.name == "startGame"
            {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size:self.size)
                self.view?.presentScene(gameScene,transition: transition)
            }
        }
    }
    
}
