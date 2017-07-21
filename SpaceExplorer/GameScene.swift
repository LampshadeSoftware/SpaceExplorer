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
	var stars2: SKSpriteNode!
	var stars3: SKSpriteNode!
	var stars4: SKSpriteNode!
	
    override func didMove(to view: SKView) {
        ship = Ship(scene: self)
		stars1 = self.childNode(withName: "stars1") as? SKSpriteNode
		stars2 = self.childNode(withName: "stars2") as? SKSpriteNode
		stars3 = self.childNode(withName: "stars3") as? SKSpriteNode
		stars4 = self.childNode(withName: "stars4") as? SKSpriteNode
		
		starsSize = stars1.size
		
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
		self.adjustStars()
		ship.update()
		self.camera!.position = ship.position()
		
	}
	
	var currentStars: SKSpriteNode!
	var currentSubQuad = 0
	var starsSize: CGSize!
	func adjustStars() {
		let pos = camera!.position
		// What starfield am I in?
		if stars1.contains(pos) {
			currentStars = stars1
		} else if stars2.contains(pos) {
			currentStars = stars2
		} else if stars3.contains(pos) {
			currentStars = stars3
		} else { // stars4 contains camera
			currentStars = stars4
		}
		
		// What quadrant of that starfield am I in?
		let subX = pos.x - currentStars.position.x
		let subY = pos.y - currentStars.position.y
		
		var newQuad: Int
		if subX >= starsSize.width / 2 {
			newQuad = 1
		} else {
			newQuad = 2
		}
		if subY < starsSize.height / 2 {
			newQuad += 2
		}
		
		// If I'm in the same quadrant as before, do nothing
		if newQuad == currentSubQuad {
			return
		} else {
			print("Moved to quad \(newQuad)")
			currentSubQuad = newQuad
		}
		
		switch currentSubQuad {
		case 4:
			stars1.position.x = pos.x.truncatingRemainder(dividingBy: starsSize.width)
			stars1.position.y = pos.y.truncatingRemainder(dividingBy: starsSize.height)
		case 3:
			stars1.position.x = pos.x.truncatingRemainder(dividingBy: starsSize.width) + starsSize.width
			stars1.position.y = pos.y.truncatingRemainder(dividingBy: starsSize.height)
		case 2:
			stars1.position.x = pos.x.truncatingRemainder(dividingBy: starsSize.width)
			stars1.position.y = pos.y.truncatingRemainder(dividingBy: starsSize.height) + starsSize.height
		case 1:
			stars1.position.x = pos.x.truncatingRemainder(dividingBy: starsSize.width) + starsSize.width
			stars1.position.y = pos.y.truncatingRemainder(dividingBy: starsSize.height) + starsSize.height
		default:
			print("something went wrong")
		}
		
		stars2.position.x = stars1.position.x - starsSize.width
		stars2.position.y = stars1.position.y
		
		stars3.position.x = stars1.position.x
		stars3.position.y = stars1.position.y - starsSize.height
		
		stars4.position.x = stars1.position.x - starsSize.width
		stars4.position.y = stars1.position.y - starsSize.height

	}
}
