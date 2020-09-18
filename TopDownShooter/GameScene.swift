//
//  GameScene.swift
//  TopDownShooter
//
//  Created by Harmeet on 06/06/2020.
//  Copyright © 2020 MysteryCoder456. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: SKNode!
    
    var keyIsDown = false;
    var keyEvent: NSEvent!
    
    var shootTimer = 0
    
    override func didMove(to view: SKView) {
        let options = [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow] as NSTrackingArea.Options
        let trackingArea = NSTrackingArea(rect:view.frame,options:options,owner:self,userInfo:nil)
        view.addTrackingArea(trackingArea)
        
        player = self.childNode(withName: "player")
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.restitution = 0.7
        border.friction = 0
        self.physicsBody = border
        
        self.makeEnemy()
    }
    
    // Helper Functions
    
    func makeBullet(shooter: SKNode) {
        let startPos = CGPoint(x: cos(shooter.zRotation) * 40 + shooter.position.x, y: sin(shooter.zRotation) * 40 + shooter.position.y)
        
        let bulletRadius: CGFloat = 5
        let bulletSpeed: CGFloat = 700
        
        // Create Bullet
        let bullet = SKShapeNode(circleOfRadius: bulletRadius)
        bullet.strokeColor = .red
        bullet.fillColor = .red
        bullet.position = startPos
        
        // Bullet's Physics Body
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bulletRadius)
        bullet.physicsBody?.restitution = 1
        bullet.physicsBody?.friction = 0
        bullet.physicsBody?.categoryBitMask = 1
        bullet.physicsBody?.collisionBitMask = 1
        bullet.physicsBody?.velocity.dx = cos(shooter.zRotation) * bulletSpeed + (shooter.physicsBody?.velocity.dx)!
        bullet.physicsBody?.velocity.dy = sin(shooter.zRotation) * bulletSpeed + (shooter.physicsBody?.velocity.dy)!
        bullet.physicsBody?.mass = 0.0001
        
        // Add To Scene
        self.addChild(bullet)
    }
    
    func makeEnemy() {
        let enemy = childNode(withName: "enemyTemplate")?.copy() as! SKNode
        enemy.name = "enemy"
        
        let posX = CGFloat.random(in: frame.minX...frame.maxX)
        let posY = CGFloat.random(in: frame.minY...frame.maxY)
        enemy.position = CGPoint(x: posX, y: posY);
        
        self.addChild(enemy)
    }
    
    
    // Keyboard Events
    
    override func keyDown(with event: NSEvent) {
        keyIsDown = true
        keyEvent = event
    }
    
    override func keyUp(with event: NSEvent) {
        keyIsDown = false
    }
    
    func keyPress(event: NSEvent) {
        let moveForce: CGFloat = 350;
        
        var moveVel = CGVector(dx: 0, dy: 0)
        
        print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        
        if event.keyCode == 123 || event.keyCode ==  0 {
            // Left
            moveVel.dx += -moveForce;
        }
        
        if event.keyCode == 124 || event.keyCode == 2 {
            // Right
            moveVel.dx += moveForce;
        }
        
        if event.keyCode == 125 || event.keyCode == 1 {
            // Down
            moveVel.dy += -moveForce;
        }
        
        if event.keyCode == 126 || event.keyCode == 13 {
            // Up
            moveVel.dy += moveForce;
        }
        
        player.physicsBody?.velocity = moveVel
    }
    
    
    // Enemy Function
    
    func moveEnemy(enemyNode: SKNode) {
        let dx = player.position.x - enemyNode.position.x
        let dy = player.position.y - enemyNode.position.y
        let angle = atan2(dy, dx)
        enemyNode.zRotation = angle
        
        let velocity = CGVector(dx: dx / 2, dy: dy / 2)
        enemyNode.physicsBody?.velocity = velocity
    }
    
    func enemyShoot(enemyNode: SKNode) {
        makeBullet(shooter: enemyNode)
    }
    
    
    // Mouse Events
    
    override func mouseDown(with event: NSEvent) {
        makeBullet(shooter: player)
    }

    override func mouseMoved(with event: NSEvent) {
        let mousePos = event.location(in: self)
        
        let dx = mousePos.x - player.position.x
        let dy = mousePos.y - player.position.y
        let angleToMouse = atan2(dy, dx)
        
        player.zRotation = angleToMouse
    }
    
    override func update(_ currentTime: TimeInterval) {
        shootTimer += 1
        
        if keyIsDown {
            keyPress(event: keyEvent)
        } else {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        if Int.random(in: 0...5000) < 2 {
            makeEnemy()
        }
        
        for node in children {
            if node.name?.contains("enemy") == true && node.name != "enemyTemplate" {
                moveEnemy(enemyNode: node)
                if shootTimer % 120 == 0 {
                    enemyShoot(enemyNode: node)
                }
            }
        }
    }
}
