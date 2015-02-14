//
//  GameScene.swift
//  MichiganHackersOneTap
//
//  Created by Spruce Bondera on 2/8/15.
//  Copyright (c) 2015 Spruce Bondera. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    var last_update_time: Double?
    var player = SKShapeNode(circleOfRadius: 20)
    var touch_offset = Vector.zero
    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        self.physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.player.position = Vector(Double(view.frame.width)/2.0,
                                      Double(player.frame.height)/2.0 +
                                      Double(view.frame.height) * 0.1 ).point
        self.player.fillColor = SKColor.blackColor()
        self.player.strokeColor = SKColor.blackColor()
        self.player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width/2)
        self.player.physicsBody?.dynamic = true
        self.addChild(player)
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            touch_offset = Vector(player.position) - Vector(touch.locationInNode(self))
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            player.position = (Vector(touch.locationInNode(self)) + touch_offset).point
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            touch_offset = Vector(0, 0)
        }
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
