//
//  ParticleSpawner.swift
//  WolfRun
//
//  Created by Ryan Needham on 14/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

import SwiftMath
import GLKit

class FlyweightModel {
    var position: Vec3 = Vec3()
    var rotation: Vec3 = Vec3()
    var velocity: Vec3 = Vec3()

    init (pos: Vec3, rot: Vec3, vel: Vec3) {
        position = pos
        rotation = rot
        velocity = vel
    }
    
    func update () {
        position += velocity
    }
}

class ParticleSpawner: Actor {
    var position: Vec3 = Vec3(x: 0, y: 0, z: 0)
    var rotation: Vec3 = Vec3(x: 0, y: 0, z: 0)
    var velocity: Vec3 = Vec3(x: 0, y: 0, z: 0)
    
    private var particle: Quad!
    private var flyweights = [FlyweightModel]()
    private var spawnRange: Float = 10.0
    
    private var rng = Random()
    
    var particleCount: Int = 10
    
    init () {
        
        // initialise particles
        particle = Quad()
        
        for _ in 0 ... particleCount {
            flyweights.append(FlyweightModel(
                pos: Vec3(x: rng.getUnsignedBasicFloat(), y: 0, z: 0),
                rot: Vec3(),
                vel: Vec3(x: 0, y: rng.getUnsignedBasicFloat(), z: 0)
            ))
        }
    }
    
    func setPosition (pos: Vec3) {
        position = pos
        
        flyweights.forEach { $0.position = pos }
    }
    
    func update () {
        flyweights.forEach {
            $0.update()
            
            let distanceFromSpawn: Float = GLKVector3Length((self.position - $0.position).asGLKVector)
            print ("distance from spawn: \(distanceFromSpawn)")
            if (distanceFromSpawn > spawnRange) {
                $0.position = self.position;
            }
        }
        
    }
    
    func draw(camera: Camera) {
        flyweights.forEach {
            particle.position = $0.position
            particle.rotation = $0.rotation
            //particle.velocity = $0.velocity
            
            print("\n")
            print($0.position.string)
            print($0.velocity.string)
            print("\n")
            
            particle.update()
            particle.draw(camera: camera)
        }
    }
}
