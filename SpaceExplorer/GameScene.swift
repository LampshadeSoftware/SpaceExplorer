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
	
	var ship: Ship!
	var stars1: SKSpriteNode!
	
    override func didMove(to view: SKView) {
        ship = Ship(scene: self)
		stars1 = self.childNode(withName: "stars1") as? SKSpriteNode

		starsSize = stars1.size
		
		self.camera = self.childNode(withName: "cam") as? SKCameraNode
	}
    
    
    func touchDown(atPoint pos : CGPoint) {
		let height = Double(scene!.size.height)
		let mappedX = pos.x - (camera?.position.x)!
		let mappedY = pos.y - (camera?.position.y)!
        let amount = Double(mappedY)*2/height * 30
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
        self.camera!.position.y += 100
	}
	
	var starsSize: CGSize!
	func adjustStars() {
		let pos = camera!.position
		// stars1.position.x = pos.x * 0.5
		// stars1.position.y = pos.y * 0.5
		let center = stars1.position
		let halfWidth = starsSize.width / 2
		let halfHeight = starsSize.height / 2
		let topEdge = center.y + halfHeight
		let bottomEdge = center.y - halfHeight
		let rightEdge = center.x + halfWidth
		let leftEdge = center.x - halfWidth
		
		if pos.x > rightEdge {
			stars1.position.x += starsSize.width
		} else if pos.x < leftEdge {
			stars1.position.x -= starsSize.width
		}
		if pos.y > topEdge {
			stars1.position.y += starsSize.height
		} else if pos.y < bottomEdge {
			stars1.position.y -= starsSize.height
		}
		
	}
}
