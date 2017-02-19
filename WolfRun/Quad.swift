//
//  Quad.swift
//  WolfRun
//
//  Created by Ryan Needham on 14/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

import SwiftMath
import OpenGLES

class Quad : Actor {
    var position: Vec3 = Vec3(x: 0, y: 0, z: 0)
    var rotation: Vec3 = Vec3(x: 0, y: 0, z: 0)
    var velocity: Vec3 = Vec3(x: 0, y: 0, z: 0)
    var colour:   Vec4 = Vec4(r: 0.21, g: 0.21, b: 0.21, a: 1.0)
    
    var shader: Shader!
    var mesh:   Mesh!
    
    var twirling = false
    
    /* [posX, posY, posZ, normX, normY, normZ] */
    var vertices: [GLfloat] = [
        -0.25, 0.0, 0.0,     0.0, 0.0, 0.0,
        -0.25, 0.5, 0.0,      0.0, 0.0, 0.0,
        0.25, 0.0, 0.0,      0.0, 0.0, 0.0,
        
        0.25, 0.0, 0.0,     0.0, 0.0, 0.0,
        0.25, 0.5, 0.0,      0.0, 0.0, 0.0,
        -0.25, 0.5, 0.0,      0.0, 0.0, 0.0
    ]
    
    init () {
        shader = Shader(path: "Shader")
        mesh   = Mesh(v: vertices)
    }
    
    func update() {
        // do movement
        position += velocity
       
        if (twirling) { rotation.y += 0.1 }
        
        // move mesh
        mesh.setPosition(x: position.x, y: position.y, z: position.z)
        mesh.setRotation(x: rotation.x, y: rotation.y, z: rotation.z)
        mesh.setColour(r: colour.r, g: colour.g, b: colour.b, a: colour.a)
        
    }
    
    func draw(camera: Camera) {
        shader.bind()
        mesh.bind()
        mesh.draw(shader: shader, camera: camera)
    }
}
