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


class AsteroidEmitter {
    
    var gameScene: SKScene!
    var spawnTheta: CGFloat!
    var center: CGPoint!
    var radius: CGFloat!
    var point1 = CGPoint(x: 0, y: 0)
    var shipMovementAngle: CGFloat!
    
    init(scene: SKScene){
        gameScene = scene
        radius = sqrt(pow(gameScene.size.width/2, 2) + pow(gameScene.size.height/2, 2))
    }
    
    func spawn(){
        
        //Get current center/point 2
        let point2 = center!
        //Get distance between points 1 and 2
        let xDistance = abs(point2.x - point1.x)
        let yDistance = abs(point2.y - point1.y)
        findShipMoveAngle(point2: point2)
        let distance = sqrt(pow(xDistance, 2) + pow(yDistance, 2))
        
        //If distance has changed a certain amount
        if(distance > 100){
            let randTime = Double(arc4random_uniform(2)) + 0.5
            let _ = Timer.scheduledTimer(timeInterval: randTime, target: self, selector: #selector(formBlockade), userInfo: nil, repeats: false)
        }
        else{
            //Ship isnt moving and asteroids should be shot at it
            let randTime = Double(arc4random_uniform(3) + 3)
            let _ = Timer.scheduledTimer(timeInterval: randTime, target: self, selector: #selector(shootAsteroids), userInfo: nil, repeats: false)
        }
        
        point1 = point2
    }
    
    @objc func formBlockade(){
        
        let asteroid = createAsteroid()
        
        let point = randomPointOnCircle(radius: radius, center: center, spawnInFront: true)
        
        asteroid.position.x = point.x
        asteroid.position.y = point.y
        
        asteroid.physicsBody?.angularVelocity = CGFloat(arc4random_uniform(8))-4
        
        gameScene.addChild(asteroid)
        
        spawn()
    }
    
    @objc func shootAsteroids(){
        
        let asteroid = createAsteroid()
        
        let point = randomPointOnCircle(radius: radius, center: center, spawnInFront: false)
        
        asteroid.position.x = point.x
        asteroid.position.y = point.y
        
        let magnitude = CGFloat(arc4random_uniform(70)+10)
        let velocity = getVelocity()
        let dx = velocity.x/radius * magnitude
        let dy = velocity.y/radius * magnitude
        asteroid.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        asteroid.physicsBody?.angularVelocity = CGFloat(arc4random_uniform(8))-4
        
        gameScene?.addChild(asteroid)
        
        spawn()
    }
    
    func createAsteroid() -> SKSpriteNode{
        
        let asteroid = SKSpriteNode(imageNamed: "asteroidTexture")
        asteroid.size = CGSize(width: 26, height: 26)
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: 13)
        asteroid.physicsBody?.restitution = 0.5
        asteroid.physicsBody?.friction = 0
        asteroid.physicsBody?.linearDamping = 0
        asteroid.physicsBody?.angularDamping = 0
        
        return asteroid
    }
    
    func randomPointOnCircle(radius:CGFloat, center:CGPoint, spawnInFront: Bool) -> CGPoint {
        if (spawnInFront == true){
            let deviation = CGFloat(drand48()) * CGFloat.pi/4 - CGFloat.pi/8
            spawnTheta = shipMovementAngle + deviation
        }
        else {
            // Random angle in [0, 2*pi]
            spawnTheta = CGFloat(drand48() * Double.pi * 2)
        }
        //Convert polar to cartesian
        let x = radius * cos(spawnTheta)
        let y = radius * sin(spawnTheta)
        
        return CGPoint(x: (x)+center.x, y: (y)+center.y)
    }
    
    func getVelocity() -> CGPoint{
        var velocity = CGPoint(x: 0, y: 0)
        
        let deviation = (spawnTheta + CGFloat.pi) + CGFloat(drand48()) * CGFloat.pi/4 - CGFloat.pi/8
        
        let dx = radius * cos(deviation)
        let dy = radius * sin(deviation)
        
        velocity.x = dx
        velocity.y = dy
        
        return velocity
    }
    
    func findShipMoveAngle(point2: CGPoint){
        let xDistance = point2.x - point1.x
        let yDistance = point2.y - point1.y
        let theta = atan(yDistance/xDistance)
        
        if(xDistance > 0){
            shipMovementAngle = theta
        }
        else{
            shipMovementAngle = theta + CGFloat.pi
        }
    }
    
    func updateCenter(point: CGPoint){
        center = point
    }
    
}
