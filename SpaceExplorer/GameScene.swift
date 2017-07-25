//
//  GameScene.swift
//  SpaceExplorer
//
//  Created by Cowboy Lynk on 7/20/17.
//  Copyright © 2017 Lampshade Software. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
    
    // Variables
	var ship: Ship!
	var stars1: SKSpriteNode!
    var emit: Emitter!
    
	
    // Touch Functions
    override func didMove(to view: SKView) {
        ship = Ship(scene: self)
		stars1 = self.childNode(withName: "stars1") as? SKSpriteNode

		starsSize = stars1.size
		
		self.camera = self.childNode(withName: "cam") as? SKCameraNode
        
        emit = Emitter(scene: scene!)
        emit.startSpawning()
	}
    
    func touchDown(atPoint pos : CGPoint) {
		let height = Double(scene!.size.height)
		let mappedX = pos.x - (camera?.position.x)!
		let mappedY = pos.y - (camera?.position.y)!
        let amount = Double(mappedY)*2/height * ship.maxThrusterAmount
		if mappedX < 0 {
			ship.setThrusterAmount(left: true, amount: amount)
		} else {
			ship.setThrusterAmount(left: false, amount: amount)
		}
    }
    
    func touchMoved(toPoint pos : CGPoint) {
		touchDown(atPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
		let mappedX = pos.x - (camera?.position.x)!
		if mappedX < 0 {
			ship.setThrusterAmount(left: true, amount: 0)
		} else {
			ship.setThrusterAmount(left: false, amount: 0)
		}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
		self.adjustStars()
		ship.update()
		self.camera!.position = ship.position()
        emit.updateCenter(point: ship.position())
        //despawn()
	}
	
    
    // Stars Background
	var starsSize: CGSize!
	var starsXOffset = 0
	var starsYOffset = 0
	let starParallax: CGFloat = 0.5
	func adjustStars() {
		let pos = self.camera!.position
		let center = stars1.position
		let halfWidth = starsSize.width / 2
		let halfHeight = starsSize.height / 2
		let topEdge = center.y + halfHeight
		let bottomEdge = center.y - halfHeight
		let rightEdge = center.x + halfWidth
		let leftEdge = center.x - halfWidth
		
		if pos.x > rightEdge {
			starsXOffset += 1
			//Moved stars right
		} else if pos.x < leftEdge {
			starsXOffset -= 1
			//Moved stars left
		}
		if pos.y > topEdge {
			starsYOffset += 1
			//Moved stars up
		} else if pos.y < bottomEdge {
			starsYOffset -= 1
			//Moved stars down
		}
		stars1.position.x = pos.x * starParallax + CGFloat(starsXOffset) * starsSize.width
		stars1.position.y = pos.y * starParallax + CGFloat(starsYOffset) * starsSize.height
	}
    
    // Auxiliary Functions
    func despawn(){
        for child in scene!.children{
            let spawnCircle = scene!.size.width/2 + 130
            let xDistance = abs(child.position.x - self.camera!.position.x)
            let yDistance = abs(child.position.y - self.camera!.position.y)
            let distance = sqrt(pow(xDistance, 2) + pow(yDistance, 2))

            if (distance > spawnCircle){
                child.removeFromParent()
            }
        }
    }
}
