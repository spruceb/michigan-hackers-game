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


class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewController: UIViewController?
    
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
    
    var lives = 3
    var score = 0

    var backgrounds: [SKSpriteNode] = []
    let backgroundScrollRate = 0.9
    
    var asteroids: [SKNode] = []
    let maxAsteroidsSideLen = 96
    var next_asteroid_time: Double?
    
    let playerCategory: UInt32 = 0x1 << 0
    let asteroidsCategory: UInt32 = 0x1 << 1
    
    func random_asteroid_location() -> Vector {
        let x = Double(random(Int(self.view!.frame.width)))
        return Vector(x, Double(self.view!.frame.height) + 1.5 * Double(maxAsteroidsSideLen))
    }
    
    func random_asteroid_speed() -> CGVector {
        return CGVector(dx: 75 - random(100), dy: -random(100, 400))
    }
    
    func random_asteroid() -> SKShapeNode {
        let size = random(10) + 1
        let radius: CGFloat = CGFloat(Int(48 / Double(size)))
        let node = SKShapeNode(circleOfRadius: radius)
        node.fillColor = UIColor.grayColor()
        node.strokeColor = UIColor.lightGrayColor()
        node.position = random_asteroid_location().point
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.width / 2)
        node.physicsBody?.velocity = random_asteroid_speed() // CGVector(dx: 0, dy: -300)
        node.physicsBody?.dynamic = true
        node.physicsBody?.categoryBitMask = asteroidsCategory
        node.physicsBody?.restitution = 0.5
        node.zPosition = 5
        return node
    }
    
    func init_player() {
        player.position = Vector(Double(self.view!.frame.width)/2.0,
            Double(player.frame.height)/2.0 +
                Double(self.view!.frame.height) * 0.1 ).point
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width/2)
        player.physicsBody?.dynamic = false
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = playerCategory | asteroidsCategory
        player.zPosition = 10
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
        self.physicsWorld.contactDelegate = self
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
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        var asteroid: SKNode? = nil
        var player: SKNode? = nil
        if contact.bodyA.categoryBitMask == asteroidsCategory {
            asteroid = contact.bodyA.node
            player = contact.bodyB.node
        } else {
            asteroid = contact.bodyB.node
            player = contact.bodyA.node
        }
        let explosion = SKEmitterNode(fileNamed: "explosion.sks")
        let scale = 1.5 * asteroid!.frame.width / CGFloat(maxAsteroidsSideLen)
        explosion.xScale = scale
        explosion.yScale = scale
        explosion.zPosition = 100
        explosion.position = asteroid!.position
        asteroid?.removeFromParent()
        self.addChild(explosion)
        explosion.numParticlesToEmit = 25
        lives -= 1
        if lives <= 0 {
            self.viewController!.performSegueWithIdentifier("gameover", sender: self)
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
            asteroids.append(asteroid)
            self.addChild(asteroid)
        }
        if currentTime > next_asteroid_time || next_asteroid_time == nil {
            next_asteroid_time = currentTime + 0.25 + 1.5 * Double(arc4random_uniform(UINT32_MAX) / UINT32_MAX)
        }
        score += 1
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
        for asteroid in asteroids {
            let view_frame = self.view!.frame
            let asteroid_rect = center_rect_at(asteroid.frame, Vector(asteroid.position))
            if !view_frame.intersects(asteroid_rect) && asteroid.position.y < view_frame.height {
                asteroid.removeFromParent()
            }
            
        }
    }
    
}
