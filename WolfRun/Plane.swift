//
//  Plane.swift
//  WolfRun
//
//  Created by user on 18/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

import SwiftMath
import OpenGLES

class Plane : Actor {
    var position: Vec3 = Vec3(x: 0, y: 0, z: 0)
    var rotation: Vec3 = Vec3(x: 0, y: 0, z: 0)
    var velocity: Vec3 = Vec3(x: 0, y: 0, z: 0)
    var colour:   Vec4 = Vec4(r: 0.21, g: 0.21, b: 0.21, a: 1.0)
    
    var shader: Shader!
    var mesh:   Mesh!
    
    private var width: GLfloat;
    private var height: GLfloat;
    
    var twirling = false
    
    /* [posX, posY, posZ, normX, normY, normZ] */
    var vertices: [GLfloat] = []
    
    init (w: GLfloat, h: GLfloat) {
        width = w
        height = h
        
        buildMesh ()
        shader = Shader(path: "Shader")
        mesh   = Mesh(v: vertices)
    }
    
    func buildMesh () {
        let startX: GLfloat = (width / 2) * -1;
        let endZ:   GLfloat = (height / 2) * -1;
        
        var xIndex: GLfloat = 0;
        var zIndex: GLfloat = height;
        
        //for (float x = startX; x < width; x += 1.0, xIndex++) {
        //    for (float z = height; z > endZ; z -= 1.0, zIndex--) {
        
        var x: GLfloat = startX
        var z: GLfloat = height
        
        while (x < width) {
            while (z > endZ) {
            
                x += 1.0
                xIndex += 1
                
                z -= 1.0
                zIndex -= 1

                // TRIANGLE 1 VERT 1
                vertices.append(GLfloat(x - 0.5));    // position x
                vertices.append(GLfloat(0.0));       // position y
                vertices.append(GLfloat(z + 0.5));    // position z
                vertices.append(GLfloat(0.0));       // normal x
                vertices.append(GLfloat(1.0));       // normal y
                vertices.append(GLfloat(0.0));       // normal z
                //vertices.append(GLfloat(xIndex/width));       // tc u PLACEHOLDER
                //vertices.append(GLfloat((zIndex-1)/height));       // tc v PLACEHOLDER
                
                // TRIANGLE 1 VERT 2
                vertices.append(GLfloat(x - 0.5));    // position x
                vertices.append(GLfloat(0.0));       // position y
                vertices.append(GLfloat(z - 0.5));    // position z
                vertices.append(GLfloat(0.0));       // normal x
                vertices.append(GLfloat(1.0));       // normal y
                vertices.append(GLfloat(0.0));       // normal z
                //vertices.append(GLfloat(xIndex/width));       // tc u PLACEHOLDER
                //vertices.append(GLfloat(zIndex/height));       // tc v PLACEHOLDER
                
                // TRIANGLE 1 VERT 3
                vertices.append(GLfloat(x + 0.5));    // position x
                vertices.append(GLfloat(0.0));       // position y
                vertices.append(GLfloat(z + 0.5));    // position z
                vertices.append(GLfloat(0.0));       // normal x
                vertices.append(GLfloat(1.0));       // normal y
                vertices.append(GLfloat(0.0));       // normal z
                //vertices.append(GLfloat((xIndex+1)/width));       // tc u PLACEHOLDER
                //vertices.append(GLfloat((zIndex-1)/height));       // tc v PLACEHOLDER
                
                // TRIANGLE 2 VERT 1
                vertices.append(GLfloat(x + 0.5));    // position x
                vertices.append(GLfloat(0.0));       // position y
                vertices.append(GLfloat(z + 0.5));    // position z
                vertices.append(GLfloat(0.0));       // normal x
                vertices.append(GLfloat(1.0));       // normal y
                vertices.append(GLfloat(0.0));       // normal z
                //vertices.append(GLfloat((xIndex+1)/width));       // tc u PLACEHOLDER
                //vertices.append(GLfloat((zIndex-1)/height));       // tc v PLACEHOLDER
                
                // TRIANGLE 2 VERT 2
                vertices.append(GLfloat(x - 0.5));    // position x
                vertices.append(GLfloat(0.0));       // position y
                vertices.append(GLfloat(z - 0.5));    // position z
                vertices.append(GLfloat(0.0));       // normal x
                vertices.append(GLfloat(1.0));       // normal y
                vertices.append(GLfloat(0.0));       // normal z
                //vertices.append(GLfloat(xIndex/width));       // tc u PLACEHOLDER
                //vertices.append(GLfloat(zIndex/height));       // tc v PLACEHOLDER
                
                // TRIANGLE 2 VERT 3
                vertices.append(GLfloat(x + 0.5));    // position x
                vertices.append(GLfloat(0.0));       // position y
                vertices.append(GLfloat(z - 0.5));    // position z
                vertices.append(GLfloat(0.0));       // normal x
                vertices.append(GLfloat(1.0));       // normal y
                vertices.append(GLfloat(0.0));       // normal z
                //vertices.append(GLfloat((xIndex+1)/width));       // tc u PLACEHOLDER
                //vertices.append(GLfloat(zIndex/height));       // tc v PLACEHOLDER
            
            }
        }

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
