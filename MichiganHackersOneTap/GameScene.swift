//
//  GameScene.swift
//  MichiganHackersOneTap
//
//  Created by Spruce Bondera on 2/8/15.
//  Copyright (c) 2015 Spruce Bondera. All rights reserved.
//

import SpriteKit

func random_color() -> UIColor {
    let colors = [UIColor.redColor(), UIColor.greenColor(), UIColor.blackColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.purpleColor()]
    let random_index = Int(arc4random_uniform(UInt32(colors.count)))
    return colors[random_index]
}


class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
    }
    
    var last_update_time: Double?
    var balls: [SKNode] = []

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let loc = touch.locationInNode(self)
            let shape = SKShapeNode(circleOfRadius: 20)
            shape.fillColor = random_color()
            shape.strokeColor = UIColor.blackColor()
            shape.physicsBody = SKPhysicsBody(circleOfRadius: shape.frame.width/2)
            shape.physicsBody?.restitution = 1
            shape.physicsBody?.linearDamping = 0
            shape.position = loc
            balls.append(shape)
            self.addChild(shape)
        }
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
