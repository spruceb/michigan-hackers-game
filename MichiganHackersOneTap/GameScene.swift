//
//  GameScene.swift
//  MichiganHackersOneTap
//
//  Created by Spruce Bondera on 2/8/15.
//  Copyright (c) 2015 Spruce Bondera. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var circle: SKShapeNode?
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.greenColor()
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
    }
    
    var last_update_time: Double?
    

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        for touch: AnyObject in touches {
//            if circle == nil {
//                let loc = touch.locationInNode(self)
//                let shape = SKShapeNode(circleOfRadius: 40)
//                shape.fillColor = UIColor.blackColor()
//                shape.strokeColor = UIColor.blackColor()
//                shape.position = loc
//                circle = shape
//                self.addChild(shape)
//            } else {
//                
//            }
//        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        // Empty
    }
   
    override func update(currentTime: CFTimeInterval) {
        if last_update_time != nil {
            // Game loop
            last_update_time = currentTime
        } else {
            last_update_time = currentTime
        }
    }
    
}
