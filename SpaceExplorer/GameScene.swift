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
    
    var isTouchingRight = false
    var isTouchingLeft = false
    
    var distanceTraveledLabel: SKLabelNode!
    var leftFuelRemainingBar: SKSpriteNode!
    var rightFuelRemainingBar: SKSpriteNode!
    var outline: SKSpriteNode!
	
	var healthLabel: SKLabelNode!
    
    var previousShipPosition = CGPoint(x: 0, y: 0)
    var distanceTraveled: CGFloat = 0
    
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
        
        
        previousShipPosition = ship.position()
        
        setUpHud()
    
	}
    
    func setUpHud(){
        outline = self.camera!.childNode(withName: "outline") as! SKSpriteNode
        distanceTraveledLabel = self.camera!.childNode(withName: "distanceTraveledLabel") as! SKLabelNode
        distanceTraveledLabel.text = "0 mi"
        //Find positions and sizes for fuel bars
        let barWidth = outline.frame.width
        let leftBarXPos = outline.position.x
        let rightBarXPos = -(outline.position.x)
        let barYPos = outline.position.y
        let barHeight = outline.frame.height
        
        //Set up left fuel bar
        //Create the fuel bar to show fuel level
        leftFuelRemainingBar = SKSpriteNode(color: SKColor.green, size: CGSize(width: barWidth, height: barHeight))
        leftFuelRemainingBar.anchorPoint = CGPoint(x: 0, y: 0)
        leftFuelRemainingBar.position = CGPoint(x: leftBarXPos, y: barYPos)
        //Create mask node to get correct shape for cropping the fuel bar
        let leftMaskNode = SKShapeNode(rect: CGRect(x: leftBarXPos, y: barYPos, width: barWidth, height: barHeight), cornerRadius: 5)
        leftMaskNode.fillColor = .gray
        //Create crop node to hold the above mask node
        let leftCropNode = SKCropNode()
        leftCropNode.maskNode = leftMaskNode
        leftCropNode.addChild(leftFuelRemainingBar)
        self.camera?.addChild(leftCropNode)
        
        //Set up right fuel bar
        //Create the fuel bar to show right level
        rightFuelRemainingBar = SKSpriteNode(color: SKColor.green, size: CGSize(width: barWidth, height: barHeight))
        rightFuelRemainingBar.anchorPoint = CGPoint(x: 1, y: 0)
        rightFuelRemainingBar.position = CGPoint(x: rightBarXPos, y: barYPos)
        //Create mask node to get correct shape for cropping the fuel bar
        let rightMaskNode = SKShapeNode(rect: CGRect(x: rightBarXPos-260, y: barYPos, width: barWidth, height: barHeight), cornerRadius: 5)
        rightMaskNode.fillColor = .gray
        //Create crop node to hold the above mask node
        let rightCropNode = SKCropNode()
        rightCropNode.maskNode = rightMaskNode
        rightCropNode.addChild(rightFuelRemainingBar)
        self.camera?.addChild(rightCropNode)
		
		healthLabel = self.camera!.childNode(withName: "health") as! SKLabelNode
        
    }

    
    // Auxiliary Functions
    func setThrusterPower(pos: CGPoint){
        let height = Double(scene!.size.height)
        let mappedX = pos.x - (camera?.position.x)!
        let mappedY = pos.y - (camera?.position.y)!
        let amount = Double(mappedY)*2/height * ship.maxThrusterPower
        if (mappedX < 0 && ship.getLeftFuel() > 0.0){
            isTouchingLeft = true
            ship.setThrusterPower(left: true, amount: amount)
        } else if (mappedX > 0 && ship.getRightFuel() > 0.0){
            isTouchingRight = true
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
            isTouchingLeft = false
			ship.setThrusterPower(left: true, amount: 0)
		} else {
            isTouchingRight = false
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
		ship.update(isTouchingLeft: isTouchingLeft, isTouchingRight: isTouchingRight)
		self.camera!.position = ship.position()
        
        // Gets the ship velocity
        asteroidEmitter.updateCenter(point: ship.position())
        
        updateHUD()
	}
	
    func updateHUD(){
        //Update positions
        
        //Update fuel Bars
        leftFuelRemainingBar.xScale = CGFloat(ship.getLeftFuel()/ship.maxFuel)
		
		/*
        //Update fuel colors
        switch (ship.getLeftFuel()){
        case 0...ship.getMaxFuel()*0.33:
            leftFuelRemainingBar.color = .red
        case ship.getMaxFuel()*0.33...ship.getMaxFuel()*0.66:
            leftFuelRemainingBar.color = .yellow
        default:
            leftFuelRemainingBar.color = .green
        }
        switch (ship.getRightFuel()){
        case 0...ship.getMaxFuel()*0.33:
            rightFuelRemainingBar.color = .red
        case ship.getMaxFuel()*0.33...ship.getMaxFuel()*0.66:
            rightFuelRemainingBar.color = .yellow
        default:
            rightFuelRemainingBar.color = .green
        }
        */
        //Update distance
        let currentShipPosition = ship.position()
        let xDistance = abs(currentShipPosition.x - previousShipPosition.x)
        let yDistance = abs(currentShipPosition.y - previousShipPosition.y)
        let distance = sqrt(pow(xDistance, 2) + pow(yDistance, 2))
        distanceTraveled += distance * 0.01
        distanceTraveledLabel.text = String(describing: Int(distanceTraveled)) + " mi"
        previousShipPosition = currentShipPosition
		
		healthLabel.text = String(describing: ship.health!)
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
