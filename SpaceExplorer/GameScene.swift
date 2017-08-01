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
    var asteroidEmitter: AsteroidEmitter!
    
	// Init
    override func didMove(to view: SKView) {
        ship = Ship(scene: self)
		stars1 = self.childNode(withName: "stars1") as? SKSpriteNode
		starsSize = stars1.size
		
		self.camera = self.childNode(withName: "cam") as? SKCameraNode
        
        // Starts the emitter for the asteroids
        asteroidEmitter = AsteroidEmitter(scene: scene!)
        asteroidEmitter.updateCenter(point: ship.position())
        asteroidEmitter.spawn()
        
        // Sets back hole radius
        let blackHole =  self.childNode(withName: "blackHole") as! SKFieldNode
        blackHole.region = SKRegion(radius: 200)
        
        let blackHoleEmitter = Emitter(scene: self, object: blackHole)
        blackHoleEmitter.birthrate = 1 // every n seconds
        blackHoleEmitter.setObjectScale(scale: 0.5)
        blackHoleEmitter.restrictObjectsTo = 2
        blackHoleEmitter.startEmitting()
	}
    
    // Auxiliary Functions
    func setThrusterPower(pos: CGPoint){
        let height = Double(scene!.size.height)
        let mappedX = pos.x - (camera?.position.x)!
        let mappedY = pos.y - (camera?.position.y)!
        let amount = Double(mappedY)*2/height * ship.maxThrusterPower
        if mappedX < 0 {
            ship.setThrusterPower(left: true, amount: amount)
        } else {
            ship.setThrusterPower(left: false, amount: amount)
        }
    }
    
    // Touch Functions
    func touchDown(atPoint pos : CGPoint) {
		setThrusterPower(pos: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
		setThrusterPower(pos: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
		let mappedX = pos.x - (camera?.position.x)!
		if mappedX < 0 {
			ship.setThrusterPower(left: true, amount: 0)
		} else {
			ship.setThrusterPower(left: false, amount: 0)
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
        
        // Gets the ship velocity
        asteroidEmitter.updateCenter(point: ship.position())
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
}
