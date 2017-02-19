//
//  Camera.swift
//  WolfRun
//
//  Created by user on 13/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

import OpenGLES
import GLKit
import SwiftMath

class Camera {
    private var position:  Vec3! = Vec3 (x: 0.0, y: 0.0, z: 0.0)
    private var target:    Vec3! = Vec3 (x: 0.0, y: 0.0, z: 0.0)
    private var direction: Vec3!

    private var viewMatrix: GLKMatrix4 = GLKMatrix4Identity
    private var projectionMatrix: GLKMatrix4 = GLKMatrix4Identity
    private var aspect: Float = 0
    
    init () {
        position = Vec3 (x: 0.0, y: 0.0, z: 0.0)
        target = Vec3 (x: 0.0, y: 0.0, z: 0.0)
        direction = (position - target)
        direction = direction.normalised
    }
    
    func update (width: Float, height: Float) {
        aspect = fabsf(Float(width / height))
        projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
        viewMatrix = GLKMatrix4Identity
    }
    
    func getViewMatrix () -> GLKMatrix4 {
        return viewMatrix
    }
    
    func getProjectionMatrix () -> GLKMatrix4 {
        return projectionMatrix
    }
}
