//
//  GameScene.swift
//  Project11
//
//  Created by Saumitra Vaidya on 3/16/16.
//  Copyright (c) 2016 agratas. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		background.zPosition = -1
		addChild(background)
		physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
	}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.locationInNode(self)
			
			let box = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 64, height: 64))
			box.position = location
			box.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 64, height: 64))
			addChild(box)
		}
	}
   
    override func update(currentTime: CFTimeInterval) {

	}
}
