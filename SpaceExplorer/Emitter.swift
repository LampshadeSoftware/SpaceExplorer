//
//  Emitter.swift
//  SpaceExplorer
//
//  Created by Cowboy Lynk on 7/31/17.
//  Copyright © 2017 Lampshade Software. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit


class Emitter {
    // Variables that user can change
    var gameScene: SKScene
    var birthrate: Double = 1.0 // number of objects emitted per second (objects/second)
    var birthrateRange: Double = 1.0 // variability in the birthrate (birthrate +/-)
    var emittedObject: SKNode
    var shouldEmit = false
    var restrictObjectsTo: Int = 0 // max objects can be on the screen at a given moment (0=inifinity)
    
    // Variables that shouldn't be chaned by user
    var ship: SKSpriteNode
    var shipPos1: CGPoint
    var radius: CGFloat
    var shipDeltaDistance: CGFloat = 0
    var objectDetector: SKShapeNode // a circle that follows the ship and checks for the number of emitted objects
    
    init(scene: SKScene, object: SKNode){
        gameScene = scene
        emittedObject = object
        
        ship = scene.childNode(withName: "body") as! SKSpriteNode
        shipPos1 = ship.position
        radius = sqrt(pow(gameScene.size.width/2, 2) + pow(gameScene.size.height/2, 2)) + 100
        objectDetector = SKShapeNode(circleOfRadius: radius)
        emit()
    }
    
    // Functions
    @objc func emit(){
        checkForMaxObjects()
        
        // Calls the function recursively
        let baseSeconds = 1/birthrate
        let randTime = baseSeconds + (drand48()*2 - 1)/birthrateRange
        let _ = Timer.scheduledTimer(timeInterval: randTime, target: self, selector: #selector(emit), userInfo: nil, repeats: false)
        
        if shouldEmit {
            let objectInstance = emittedObject.copy() as! SKNode
            let angle = getSpawnAngle()
            objectInstance.position.x = radius*cos(angle) + ship.position.x
            objectInstance.position.y = radius*sin(angle) + ship.position.y
                
            self.gameScene.addChild(objectInstance)
        }
    }
    
    func startEmitting(){
        shouldEmit = true
    }
    
    func stopEmitting(){
        shouldEmit = false
    }
    
    @objc func checkForMaxObjects(){
        if restrictObjectsTo != 0{ // If there is a restriction on the number of objects, do:
            objectDetector.position = ship.position
            var counter = 0
            for child in gameScene.children{ // counts the number of emitted objects in the scene
                if child.name == emittedObject.name{
                    if objectDetector.contains(child.position){
                        counter += 1
                    }
                }
            }
            if counter >= restrictObjectsTo{
                stopEmitting()
            } else {
                startEmitting()
            }
        }
    }
    
    func getSpawnAngle() -> CGFloat{
        let shipPos2 = ship.position
        var shipMovementAngle: CGFloat
        
        let xDistance = shipPos2.x - shipPos1.x
        let yDistance = shipPos2.y - shipPos1.y
        let theta = atan(yDistance/xDistance)
        
        // Fixes the angle if its on the other side of the unit circle
        if(xDistance > 0){
            shipMovementAngle = theta
        }
        else{
            shipMovementAngle = theta + CGFloat.pi
        }
        
        // Updates the position of the first point
        shipPos1 = shipPos2
        
        // Adds variation to the angle
        shipMovementAngle = shipMovementAngle + CGFloat(drand48()*2 - 1)*CGFloat.pi / 2
        
        return shipMovementAngle
    }
    
    func setObjectScale
        (scale: CGFloat){
        emittedObject.setScale(scale)
    }

}
