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
    var current_ball: SKNode?
    var last_position: Vector?
    var next_velocity: Vector = Vector(0,0)
    var last_touch_time: Double = NSDate.timeIntervalSinceReferenceDate()
    var offset = Vector(0,0)
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let loc = touch.locationInNode(self)
            last_position = Vector(loc)
            last_touch_time = NSDate.timeIntervalSinceReferenceDate()
            var body = self.physicsWorld.bodyAtPoint(loc)
            next_velocity = Vector(0,0)
            if body != nil {
                offset = Vector(body!.node!.position) - last_position!
                if abs(offset) > (Double(body!.node!.frame.width) / 2) {
                    offset = Vector.zero
                    break
                }
                current_ball = body!.node
                body!.dynamic = false
                break
            } else {
                let shape = SKShapeNode(circleOfRadius: 20)
                shape.fillColor = random_color()
                shape.strokeColor = UIColor.blackColor()
                shape.physicsBody = SKPhysicsBody(circleOfRadius: shape.frame.width/2)
                shape.physicsBody?.restitution = 1
                shape.physicsBody?.linearDamping = 0
                shape.physicsBody?.dynamic = false
                shape.position = loc
                offset = Vector(0,0)
                balls.append(shape)
                current_ball = shape
                self.addChild(shape)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let time = NSDate.timeIntervalSinceReferenceDate()
            let loc = Vector(touch.locationInNode(self))
            if last_position != nil && current_ball != nil{
                next_velocity = 0.75 * (loc - Vector(current_ball!.position)) / (time - last_touch_time)
                current_ball?.position = (loc + offset).point
                last_touch_time = time
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            if NSDate.timeIntervalSinceReferenceDate() - last_touch_time > 0.05 {
                next_velocity = Vector.zero
            }
            current_ball?.physicsBody?.dynamic = true
            current_ball?.physicsBody?.velocity = next_velocity.vec
            current_ball = nil
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
