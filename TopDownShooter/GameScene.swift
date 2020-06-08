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
    
    override func didMove(to view: SKView) {
        let options = [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow] as NSTrackingArea.Options
        let trackingArea = NSTrackingArea(rect:view.frame,options:options,owner:self,userInfo:nil)
        view.addTrackingArea(trackingArea)
        
        player = self.childNode(withName: "player")
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.restitution = 1
        border.friction = 0
        self.physicsBody = border
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
        
        print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        
        if event.keyCode == 123 || event.keyCode ==  0 {
            // Left
            player.physicsBody?.velocity.dx = -moveForce;
        }
        
        if event.keyCode == 124 || event.keyCode == 2 {
            // Right
            player.physicsBody?.velocity.dx = moveForce;
        }
        
        if event.keyCode == 125 || event.keyCode == 1 {
            // Down
            player.physicsBody?.velocity.dy = -moveForce;
        }
        
        if event.keyCode == 126 || event.keyCode == 13 {
            // Up
            player.physicsBody?.velocity.dy = moveForce;
        }
    }
    
    
    // Mouse Events
    
    override func mouseDown(with event: NSEvent) {
        let startPos = CGPoint(x: cos(player.zRotation) * 40 + player.position.x, y: sin(player.zRotation) * 40 + player.position.y)
        
        let bulletRadius: CGFloat = 5
        let bulletSpeed: CGFloat = 500
        
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
        bullet.physicsBody?.velocity.dx = cos(player.zRotation) * bulletSpeed
        bullet.physicsBody?.velocity.dy = sin(player.zRotation) * bulletSpeed
        bullet.physicsBody?.mass = 0.01
        
        // Add To Scene
        self.addChild(bullet)
    }

    override func mouseMoved(with event: NSEvent) {
        let mousePos = event.location(in: self)
        
        let dx = mousePos.x - player.position.x
        let dy = mousePos.y - player.position.y
        let angleToMouse = atan2(dy, dx)
        
        player.zRotation = angleToMouse
    }
    
    override func update(_ currentTime: TimeInterval) {
        if keyIsDown {
            keyPress(event: keyEvent)
        } else {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }
}
