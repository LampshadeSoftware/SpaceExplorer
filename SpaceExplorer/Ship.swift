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
	
    var maxThrusterAmount = 30.0
	var leftThrusterAmount = 0.0
	var rightThrusterAmount = 0.0
	
    
	init(scene: SKScene) {
		body = scene.childNode(withName: "body") as! SKSpriteNode
        leftThruster = body.childNode(withName: "leftThruster") as! SKEmitterNode
        rightThruster = body.childNode(withName: "rightThruster") as! SKEmitterNode
        leftSmoke = body.childNode(withName: "leftSmoke") as! SKEmitterNode
        rightSmoke = body.childNode(withName: "rightSmoke") as! SKEmitterNode
	}
	
	func setThrusterAmount(left: Bool, amount: Double) {
		if left {
			leftThrusterAmount = amount
		} else {
			rightThrusterAmount = amount
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
		let left = getEdgePoint(left: true)
		let right = getEdgePoint(left: false)
		
		let ratio = leftThrusterAmount / rightThrusterAmount
		if ratio > 0.9 && ratio < 1.1 {
			leftThrusterAmount = rightThrusterAmount
		}
		
		let leftXComp = cos(body.zRotation + CGFloat.pi/2) * CGFloat(leftThrusterAmount)
		let leftYComp = sin(body.zRotation + CGFloat.pi/2) * CGFloat(leftThrusterAmount)
		self.body.physicsBody?.applyForce(CGVector(dx: leftXComp, dy: leftYComp), at: left)
		
		let rightXComp = cos(body.zRotation + CGFloat.pi/2) * CGFloat(rightThrusterAmount)
		let rightYComp = sin(body.zRotation + CGFloat.pi/2) * CGFloat(rightThrusterAmount)
		self.body.physicsBody?.applyForce(CGVector(dx: rightXComp, dy: rightYComp), at: right)
		
		leftThruster.particleLifetime = CGFloat(0.5 * (leftThrusterAmount / maxThrusterAmount))
        rightThruster.particleLifetime = CGFloat(0.5 * (rightThrusterAmount / maxThrusterAmount))
        
        leftSmoke.emissionAngle = body.zRotation + CGFloat.pi/2
        rightSmoke.emissionAngle = body.zRotation + CGFloat.pi/2
        
        leftSmoke.particleLifetime = CGFloat(2.0 * (leftThrusterAmount / maxThrusterAmount))
        rightSmoke.particleLifetime = CGFloat(2.0 * (rightThrusterAmount / maxThrusterAmount))
	}
	
	func position()  -> CGPoint {
		return body.position
	}
	
}
