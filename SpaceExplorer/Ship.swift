//
//  Ship.swift
//  SpaceExplorer
//
//  Created by Daniel McCrystal on 7/20/17.
//  Copyright © 2017 Lampshade Software. All rights reserved.
//

import Foundation
import SpriteKit

class Ship {
	var body: SKSpriteNode
    var leftThruster: SKEmitterNode
    var rightThruster: SKEmitterNode
    var leftSmoke: SKEmitterNode
    var rightSmoke: SKEmitterNode
	
    var maxThrusterPower = 100.0
	var leftThrusterPower = 0.0  // current thruster power (e.g. how far up/down the screen the user has their finger)
	var rightThrusterPower = 0.0
	
    
	init(scene: SKScene) {
		body = scene.childNode(withName: "body") as! SKSpriteNode
        leftThruster = body.childNode(withName: "leftThruster") as! SKEmitterNode
        rightThruster = body.childNode(withName: "rightThruster") as! SKEmitterNode
        leftSmoke = body.childNode(withName: "leftSmoke") as! SKEmitterNode
        rightSmoke = body.childNode(withName: "rightSmoke") as! SKEmitterNode
	}
	
	func setThrusterPower(left: Bool, amount: Double) {
		if left {
			leftThrusterPower = amount
		} else {
			rightThrusterPower = amount
		}
	}
	
	func getEdgePoint(left: Bool) -> CGPoint {
		let len = body.size.width / 2 - 10
		
		var rotation = body.zRotation
		if left {
			rotation += CGFloat.pi
		}
		let x = cos(rotation) * len
		let y = sin(rotation) * len
		
		return CGPoint(x: body.position.x + x, y: body.position.y + y)
	}
	
	func update() {
        // Finds the points at the edges of the ship where the force should be applied
		let left = getEdgePoint(left: true)
		let right = getEdgePoint(left: false)
		
        // Makes the powers the same if they are close enough to eachother
		let ratio = leftThrusterPower / rightThrusterPower
		if ratio > 0.9 && ratio < 1.1 {
			leftThrusterPower = rightThrusterPower
		}
		
        // Applies a force on the left side of the ship
		let leftXComp = cos(body.zRotation + CGFloat.pi/2) * CGFloat(leftThrusterPower)
		let leftYComp = sin(body.zRotation + CGFloat.pi/2) * CGFloat(leftThrusterPower)
		self.body.physicsBody?.applyForce(CGVector(dx: leftXComp, dy: leftYComp), at: left)
		
        // Applies a force on the riht side of the ship
		let rightXComp = cos(body.zRotation + CGFloat.pi/2) * CGFloat(rightThrusterPower)
		let rightYComp = sin(body.zRotation + CGFloat.pi/2) * CGFloat(rightThrusterPower)
		self.body.physicsBody?.applyForce(CGVector(dx: rightXComp, dy: rightYComp), at: right)
		
        // Sets alpha and emission angle of the thrusters and smoke 
		leftThruster.particleLifetime = CGFloat(0.5 * (leftThrusterPower / maxThrusterPower))
        rightThruster.particleLifetime = CGFloat(0.5 * (rightThrusterPower / maxThrusterPower))
        leftSmoke.emissionAngle = body.zRotation + CGFloat.pi/2
        rightSmoke.emissionAngle = body.zRotation + CGFloat.pi/2
        leftSmoke.particleAlpha = CGFloat(0.06 * (leftThrusterPower / maxThrusterPower))
        rightSmoke.particleAlpha = CGFloat(0.06 * (rightThrusterPower / maxThrusterPower))
	}
	
	func position()  -> CGPoint {
		return body.position
	}
	
}
