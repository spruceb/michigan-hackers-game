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
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // TODO
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // TODO
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // TODO
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
