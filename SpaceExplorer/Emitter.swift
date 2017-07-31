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
    // Variables
    var gameScene: SKScene
    var birthrate: Double = 1.0 // number of objects emitted per second (objects/second)
    var birthrateRange: Double = 1.0 // variability in the birthrate (birthrate +/-)
    var emittedObject: SKNode
    
    init(scene: SKScene, object: SKNode){
        gameScene = scene
        emittedObject = object
        let _ = Timer.scheduledTimer(timeInterval: 1/birthrate, target: self, selector: #selector(startEmitting), userInfo: nil, repeats: false)
    }
    
    // Functions
    @objc func startEmitting(){
        let objectInstance = emittedObject.copy() as! SKNode
        objectInstance.position.x = 10
        objectInstance.position.y = 10
        
        self.gameScene.addChild(objectInstance)
        
        // Calls the function recursively
        let baseSeconds = 1/birthrate
        let randTime = baseSeconds - (drand48()*2 - 1)/birthrateRange
        let _ = Timer.scheduledTimer(timeInterval: randTime, target: self, selector: #selector(startEmitting), userInfo: nil, repeats: false)
    }
    
    func stopEmitting(){
        
    }
    func setObjectScale
        (scale: CGFloat){
        emittedObject.setScale(scale)
    }

}
