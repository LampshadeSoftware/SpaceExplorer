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
	
    override func didMove(to view: SKView) {
        ship = Ship(scene: self)
		self.camera = self.childNode(withName: "cam") as? SKCameraNode
	}
    
    
    func touchDown(atPoint pos : CGPoint) {
		let height = Double(scene!.size.height)
		let mappedX = pos.x - (camera?.position.x)!
		let mappedY = pos.y - (camera?.position.y)!
		let amount = (Double(mappedY) + height / 2) / height * 100.0
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
		ship.update()
		self.camera!.position = ship.position()
	}
}
