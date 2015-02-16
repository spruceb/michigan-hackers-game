//
//  GameScene.swift
//  MichiganHackersOneTap
//
//  Created by Spruce Bondera on 2/8/15.
//  Copyright (c) 2015 Spruce Bondera. All rights reserved.
//

import SpriteKit

func random(max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)))
}

func random(low: Int, high: Int) -> Int {
    return random(high) + low
}


class GameScene: SKScene {
    var last_update_time: Double?
    var player = SKSpriteNode(imageNamed: "player")
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
    
    var backgrounds: [SKSpriteNode] = []
    let backgroundScrollRate = 0.9
    
    var asteroids: [SKNode] = []
    let maxAsteroidsSideLen = 96
    var next_asteroid_time: Double?
    
    func random_asteroid_location() -> Vector {
        let x = Double(random(Int(self.view!.frame.width)))
        return Vector(x, Double(self.view!.frame.height) + 1.5 * Double(maxAsteroidsSideLen))
    }
    
    func random_asteroid_speed() -> CGVector {
        return CGVector(dx: 50 - random(100), dy: -random(100, 300))
    }
    
    func random_asteroid() -> SKShapeNode {
        let size = random(4)
        let node = SKShapeNode(circleOfRadius: CGFloat(48.0 / pow(2.0, Double(size))))
        node.fillColor = UIColor.grayColor()
        node.position = random_asteroid_location().point
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.width / 2)
        node.physicsBody?.velocity = random_asteroid_speed() // CGVector(dx: 0, dy: -300)
        node.physicsBody?.dynamic = true
        node.zPosition = 5
        return node
    }
    
    func init_player() {
        self.player.position = Vector(Double(self.view!.frame.width)/2.0,
            Double(player.frame.height)/2.0 +
                Double(self.view!.frame.height) * 0.1 ).point
        self.player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width/2)
        self.player.physicsBody?.dynamic = false
        self.player.zPosition = 10
        self.addChild(player)
    }
    
    func init_background() {
        var background_images = [SKSpriteNode(imageNamed: "background_1"), SKSpriteNode(imageNamed: "background_2")]
        for i in 0..<2 {
            var background = background_images[i]
            background.size = self.view!.frame.size
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint(x: 0, y: CGFloat(i) * background.size.height - CGFloat(i))
            background.zPosition = -100
            self.addChild(background)
            backgrounds.append(background)
        }
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        self.physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        init_background()
        init_player()
        self.view?.multipleTouchEnabled
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            last_touch_position = Vector(touch.locationInNode(self))
        }
    }
    
    func new_player_pos_in_bounds(pos: Vector) -> Bool {
        let new_frame = center_rect_at(self.player.frame, pos)
        return self.view!.frame.contains(new_frame)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
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
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            last_touch_position = Vector(touch.locationInNode(self))

        }
    }
    
    func background_update(delta_t: Double) {
        let screen_height = self.view!.frame.height
        for i in 0..<2 {
            let image = backgrounds[i]
            if image.position.y < -screen_height {
                image.position.y = backgrounds[1-i].position.y + image.size.height
            }
            image.position.y -= CGFloat(backgroundScrollRate * Double(screen_height) * delta_t)
        }
    }
    
    func add_asteroid(currentTime: Double) {
        if currentTime > next_asteroid_time {
            let asteroid = random_asteroid()
            self.addChild(asteroid)
        }
        if currentTime > next_asteroid_time || next_asteroid_time == nil {
            next_asteroid_time = currentTime + 0.5 + 1.5 * Double(arc4random_uniform(UINT32_MAX) / UINT32_MAX)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if last_update_time == nil {
            // Game loop
            last_update_time = currentTime
        }
        let delta_t = currentTime - last_update_time!
        background_update(delta_t)
        add_asteroid(currentTime)
        last_update_time = currentTime
    }
    
}
