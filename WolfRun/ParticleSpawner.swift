//
//  ParticleSpawner.swift
//  WolfRun
//
//  Created by Ryan Needham on 14/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

import SwiftMath

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
    
    private var particle: Triangle!
    private var flyweights = [FlyweightModel]()
    
    private var rng = Random()
    
    var particleCount: Int = 200
    
    init () {
        
        // initialise particles
        particle = Triangle()
        
        for i in (particleCount/2) * -1 ... particleCount/2 { flyweights.append(FlyweightModel(
            pos: Vec3(x: Float(Float(i) * 0.5), y: 0, z: 0),
            rot: Vec3(),
            vel: Vec3(x: rng.getUnsignedBasicFloat() * 0.01, y: rng.getUnsignedBasicFloat() * 0.01, z: 0)
        ))}
    }
    
    func setPosition (pos: Vec3) {
        position = pos
        
        flyweights.forEach { $0.position = pos }
    }
    
    func update () {
        flyweights.forEach { $0.update() }
    }
    
    func draw(camera: Camera) {
        flyweights.forEach {
            particle.position = $0.position
            particle.rotation = $0.rotation
            particle.velocity = $0.velocity
            
            print("\n")
            print($0.position.toString())
            print($0.velocity.toString())
            print("\n")
            
            particle.update()
            particle.draw(camera: camera)
        }
    }
}
