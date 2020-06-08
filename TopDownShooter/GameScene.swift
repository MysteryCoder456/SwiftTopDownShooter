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
    var gameEvent: NSEvent!
    
    override func didMove(to view: SKView) {
        player = childNode(withName: "player")
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.restitution = 1
        border.friction = 0
        self.physicsBody = border
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

    override func mouseMoved(with event: NSEvent) {
    }
    
    override func keyDown(with event: NSEvent) {
        keyIsDown = true
        gameEvent = event
    }
    
    override func keyUp(with event: NSEvent) {
        keyIsDown = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if keyIsDown {
            keyPress(event: gameEvent)
        } else {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }
}
