//
//  GameScene.swift
//  Project11
//
//  Created by Saumitra Vaidya on 3/16/16.
//  Copyright (c) 2016 agratas. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var scoreLabel: SKLabelNode!
	
	var score: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	var editLabel: SKLabelNode!
	
	var editing: Bool = false {
		didSet {
			if editing {
				editLabel.text = "Done"
			} else {
				editLabel.text = "Edit"
			}
		}
	}
	
	
    override func didMoveToView(view: SKView) {
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		background.zPosition = -2
		addChild(background)
		
		physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
		physicsWorld.contactDelegate = self
		
		makeSlotAt(CGPoint(x: 128, y: 0), good: true)
		makeSlotAt(CGPoint(x: 384, y: 0), good: false)
		makeSlotAt(CGPoint(x: 640, y: 0), good: true)
		makeSlotAt(CGPoint(x: 896, y: 0), good: false)
		
		makeBouncerAt(CGPoint(x: 0, y: 0))
		makeBouncerAt(CGPoint(x: 256, y: 0))
		makeBouncerAt(CGPoint(x: 512, y: 0))
		makeBouncerAt(CGPoint(x: 768, y: 0))
		makeBouncerAt(CGPoint(x: 1024, y: 0))
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .Right
		scoreLabel.position = CGPoint(x: 980, y: 700)
		addChild(scoreLabel)
		
		editLabel = SKLabelNode(fontNamed: "Chalkduster")
		editLabel.text = "Edit"
		editLabel.position = CGPoint(x: 80, y: 700)
		addChild(editLabel)
	}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.locationInNode(self)
			
			let objects = nodesAtPoint(location) as [SKNode]
			
			if objects.contains(editLabel) {
				editing = !editing
			} else {
				if editing {
					let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
					let box = SKSpriteNode(color: RandomColor(), size: size)
					box.zRotation = RandomCGFloat(min: 0, max: 3)
					box.position = location
					
					box.physicsBody = SKPhysicsBody(rectangleOfSize: box.size)
					box.physicsBody!.dynamic = false
					
					addChild(box)
				} else {
					let ball = SKSpriteNode(imageNamed: "ballRed")
					ball.position = location
					ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
					ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
					ball.physicsBody!.restitution = 0.4
					ball.name = "ball"
					addChild(ball)
				}
			}
			
		}
	}
   
    override func update(currentTime: CFTimeInterval) {

	}
	
	func makeBouncerAt(position: CGPoint) {
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = position
		bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
		bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
		bouncer.physicsBody!.dynamic = false
		addChild(bouncer)
	}
	
	func makeSlotAt(position: CGPoint, good isGood: Bool) {
		let slotBase: SKSpriteNode
		let slotGlow: SKSpriteNode
		
		if isGood {
			slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
			slotBase.name = "good"
			slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
		} else {
			slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
			slotBase.name = "bad"
			slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
		}
		
		slotBase.position = position
		slotGlow.position = position
		
		slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
		slotBase.physicsBody!.dynamic = false
		
		addChild(slotBase)
		addChild(slotGlow)
		
		let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
		let spinForever = SKAction.repeatActionForever(spin)
		slotGlow.runAction(spinForever)

	}
	
	func collisionBetweenBall(ball: SKNode, object: SKNode) {
		if object.name == "good" {
			destroyBall(ball)
			score += 1
		} else if object.name == "bad" {
			destroyBall(ball)
			score -= 1
		}
	}
	
	func destroyBall(ball: SKNode) {
		if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
			fireParticles.position = ball.position
			addChild(fireParticles)
		}
		ball.removeFromParent()
	}
	
	func didBeginContact(contact: SKPhysicsContact) {
		if contact.bodyA.node!.name == "ball" {
			collisionBetweenBall(contact.bodyA.node!, object: contact.bodyB.node!)
		} else if contact.bodyB.node!.name == "ball" {
			collisionBetweenBall(contact.bodyB.node!, object: contact.bodyA.node!)
		}
	}
}
