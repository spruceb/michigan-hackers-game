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
    var last_touch_position: Vector?
    var touch_offset: Vector {
        get {
            if last_touch_position == nil {
                return Vector.zero
            } else {
                return Vector(player.position) - last_touch_position!
            }
        }
    }
    
    
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
        self.player.physicsBody?.dynamic = false
        self.addChild(player)
        
        self.view?.multipleTouchEnabled
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            last_touch_position = Vector(touch.locationInNode(self))
        }
    }
    
    func new_player_pos_in_bounds(pos: Vector) -> Bool {
        let new_frame = center_rect_at(self.player.frame, pos)
        return self.view!.frame.contains(new_frame)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            println("newtouch")
            let touch_pos = Vector(touch.locationInNode(self))
            let player_pos = Vector(self.player.position)
            let new_pos = touch_pos + touch_offset
            if new_player_pos_in_bounds(new_pos) {
                self.player.position = new_pos.point
            } else if new_player_pos_in_bounds(new_pos.x_vec + player_pos.y_vec) {
                self.player.position = (new_pos.x_vec + player_pos.y_vec).point
            } else if new_player_pos_in_bounds(new_pos.y_vec + player_pos.x_vec) {
                self.player.position = (new_pos.y_vec + player_pos.x_vec).point
            }
            last_touch_position = touch_pos
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            last_touch_position = Vector(touch.locationInNode(self))

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
