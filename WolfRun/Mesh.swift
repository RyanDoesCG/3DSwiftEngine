/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  Mesh.swift
 *  WolfRun
 *
 *  Created by user on 13/02/2017.
 *  Copyright © 2017 Baked Goods Studios. All rights reserved.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
import OpenGLES
import GLKit
import SwiftMath

class Mesh {

    // gl state
    private var VAO: GLuint = 0
    private var VBO: GLuint = 0
    private var vertData: [GLfloat]
    
    private let UNIFORM_MODEL = 0
    private let UNIFORM_VIEW = 1
    private let UNIFORM_PROJECTION = 2
    private let UNIFORM_NORMAL_MATRIX = 3
    private let UNIFORM_COLOUR = 4
    private var uniforms = [GLint](repeating: 0, count: 5)
    
    // transformation matrices
    private var model: GLKMatrix4 = GLKMatrix4Identity
    
    private var normalMatrix: GLKMatrix3 = GLKMatrix3Identity
    
    private var position: Vec3 = Vec3(x: 0, y: 0, z: 0)
    private var rotation: Vec3 = Vec3(x: 0, y: 0, z: 0)
    private var colour:   Vec4 = Vec4(r: 0.24, g: 0.0, b: 0.0, a: 1.0)
    
    init (v: [GLfloat]) {
        vertData = v
    
        glGenVertexArraysOES(1, &VAO)
        glBindVertexArrayOES(VAO)
        
        glGenBuffers(1, &VBO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<GLfloat>.size * vertData.count), &vertData, GLenum(GL_STATIC_DRAW))
        
        // Position Attrib
        glEnableVertexAttribArray (GLuint(GLKVertexAttrib.position.rawValue))
        glVertexAttribPointer     (GLuint(GLKVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, nil)
        
        // Normal Attrib
        glEnableVertexAttribArray (GLuint(GLKVertexAttrib.normal.rawValue))
        glVertexAttribPointer     (GLuint(GLKVertexAttrib.normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, BUFFER_OFFSET(12))
        
        glBindVertexArrayOES(0)
    }
    
    deinit {
        glDeleteBuffers(1, &VBO)
        glDeleteVertexArraysOES(1, &VAO)
    }
    
    func bind () {
        glBindVertexArrayOES(VAO)
    }
    
    func setPosition (x: Float, y: Float, z: Float)           { position = Vec3(x:x, y:y, z:z) }
    func setRotation (x: Float, y: Float, z: Float)           { rotation = Vec3(x:x, y:y, z:z) }
    func setColour   (r: Float, g: Float, b: Float, a: Float) { colour   = Vec4(r:r, g:g, b:b, a:a) }
    
    func draw (shader: Shader, camera: Camera) {
        
        // make model
        model = GLKMatrix4MakeTranslation(position.x, position.y, position.z)
        model = GLKMatrix4Rotate(model, rotation.x, 1.0, 0.0, 0.0)
        model = GLKMatrix4Rotate(model, rotation.y, 0.0, 1.0, 0.0)
        model = GLKMatrix4Rotate(model, rotation.z, 0.0, 0.0, 1.0)
        
        // make viewProjection
        var viewMat             = camera.getViewMatrix()
        var projMat             = camera.getProjectionMatrix()
        let modelView           = GLKMatrix4Multiply(model, viewMat)
        let modelViewProjection = GLKMatrix4Multiply(modelView, projMat)
        
        // will fuck up lighting
        normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewProjection), nil)
        
        // make colour
        var colourUni = colour.asGLKVector
        
        uniforms[UNIFORM_MODEL]          = glGetUniformLocation(shader.getProgramID(), "model")
        uniforms[UNIFORM_VIEW]           = glGetUniformLocation(shader.getProgramID(), "view")
        uniforms[UNIFORM_PROJECTION]     = glGetUniformLocation(shader.getProgramID(), "projection")
        uniforms[UNIFORM_NORMAL_MATRIX]  = glGetUniformLocation(shader.getProgramID(), "normal")
        uniforms[UNIFORM_COLOUR]         = glGetUniformLocation(shader.getProgramID(), "colour")

        
        withUnsafePointer(to: &model, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(uniforms[UNIFORM_MODEL], 1, 0, $0)
            })
        })
        
        withUnsafePointer(to: &viewMat, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(uniforms[UNIFORM_VIEW], 1, 0, $0)
            })
        })
        
        withUnsafePointer(to: &projMat, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(uniforms[UNIFORM_PROJECTION], 1, 0, $0)
            })
        })
        
        withUnsafePointer(to: &normalMatrix, {
            $0.withMemoryRebound(to: Float.self, capacity: 9, {
                glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, $0)
            })
        })
        
        withUnsafePointer(to: &colourUni, {
            $0.withMemoryRebound(to: Float.self, capacity: 9, {
                glUniform4fv(uniforms[UNIFORM_COLOUR], 1, $0)
            })
        })
        
    
        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(vertData.count / 6))
    }
}
