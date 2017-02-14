/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  Mesh.swift
 *  WolfRun
 *
 *  Created by user on 13/02/2017.
 *  Copyright © 2017 Baked Goods Studios. All rights reserved.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
import OpenGLES
import GLKit

class Mesh {

    // gl state
    private var VAO: GLuint = 0
    private var VBO: GLuint = 0
    private var vertData: [GLfloat]
    
    // transformation matrices
    private var model: GLKMatrix4 = GLKMatrix4Identity
    
    private var normalMatrix:              GLKMatrix3 = GLKMatrix3Identity
    private var rotation:                  Float      = 0.0
    
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
    
    func update () {
        rotation += 0.1
    }
    
    func draw (shader: Shader, camera: Camera) {
        model = GLKMatrix4MakeTranslation(0.0, 0.0, -4.0)
        model = GLKMatrix4Rotate(model, rotation, 0.0, 1.0, 0.0)
        
        var viewMat = camera.getViewMatrix()
        var projMat = camera.getProjectionMatrix()
        
        // will fuck up lighting
        normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(model), nil)
        
        uniforms[UNIFORM_MODEL] = glGetUniformLocation(shader.getProgramID(), "model")
        uniforms[UNIFORM_VIEW] = glGetUniformLocation(shader.getProgramID(), "view")
        uniforms[UNIFORM_PROJECTION] = glGetUniformLocation(shader.getProgramID(), "projection")
        
        uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(shader.getProgramID(), "normal")

        
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
        
    
        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(vertData.count / 6))
    }
}
