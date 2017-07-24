//
//  Emitter.swift
//  asteroid
//
//  Created by Rio Lynk on 7/22/17.
//  Copyright © 2017 Lampshade Software. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit


class Emitter{
    
    var gameScene: SKScene!
    var theta: CGFloat!
    var center: CGPoint!
    
    init(scene: SKScene){
        
        gameScene = scene
    }
    
    func startSpawning(){
        let _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(createAsteroid), userInfo: nil, repeats: true)
    }
    
    @objc func createAsteroid(){
        despawn()
        
        let width = CGFloat(gameScene.size.width)
        let point = randomPointOnCircle(radius: width/2+100, center: center)
        let xPos = point.x
        let yPos = point.y
        
        let asteroid = SKSpriteNode(imageNamed: "asteroidTexture")
        asteroid.size = CGSize(width: 26, height: 26)
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: 13)
        asteroid.physicsBody?.restitution = 0.5
        asteroid.physicsBody?.friction = 0
        asteroid.physicsBody?.linearDamping = 0
        asteroid.physicsBody?.angularDamping = 0
        
        asteroid.position.x = xPos
        asteroid.position.y = yPos
        
        let magnitude = CGFloat(drand48()*0.03)
        let deviation = getDeviation()
        let dx = (-xPos+deviation.x)*magnitude
        let dy = (-yPos+deviation.y)*magnitude
        
        asteroid.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        asteroid.physicsBody?.angularVelocity = CGFloat(arc4random_uniform(8))-4
        
        gameScene?.addChild(asteroid)
        
    }
    
    func randomPointOnCircle(radius:CGFloat, center:CGPoint) -> CGPoint {
        // Random angle in [0, 2*pi]
        theta = CGFloat(drand48() * Double.pi * 2)
        //Convert polar to cartesian
        let x = radius * cos(theta)
        let y = radius * sin(theta)
        return CGPoint(x: (x)+center.x, y: (y)+center.y)
    }
    
    func getDeviation() -> CGPoint{
        var deviation = CGPoint(x: 0, y: 0)
        let xVariation = gameScene.size.width/2
        let yVariation = gameScene.size.height/2
        
        //If in top or bottom sector
        if((CGFloat.pi/4<theta && theta<3*CGFloat.pi/4) || ((5*CGFloat.pi/4<theta) && (theta<7*CGFloat.pi/4))){
            //Create random x deviation amount
            let xDev = CGFloat(arc4random_uniform(UInt32(xVariation))) - (xVariation/2)
            //Add it to x of deviation point
            deviation.x = xDev
        }
        else{
            //Create random y deviation amount
            let yDev = CGFloat(arc4random_uniform(UInt32(yVariation))) - (yVariation/2)
            //Add it to y of deviation point
            deviation.y = yDev
        }
        
        return deviation
    }
    
    func updateCenter(point: CGPoint){
        center = point
    }
    
    func despawn(){
        for child in gameScene.children{
            if (child.position.x > gameScene.size.width/2+130 + center.x || child.position.x < -gameScene.size.width/2-130 + center.x){
                child.removeFromParent()
            }
            else if(child.position.y > gameScene.size.width/2+130 + center.y || child.position.y < -gameScene.size.width/2-130 + center.y){
                child.removeFromParent()
            }
        }
    }
    
}
