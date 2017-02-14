//
//  Camera.swift
//  WolfRun
//
//  Created by user on 13/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

import OpenGLES
import GLKit

class Camera {
    private var viewMatrix: GLKMatrix4 = GLKMatrix4Identity
    private var projectionMatrix: GLKMatrix4 = GLKMatrix4Identity
    private var aspect: Float = 0
    
    init () {}
    
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
