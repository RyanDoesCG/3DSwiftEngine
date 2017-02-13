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
    private var VAO: GLuint = 0
    private var VBO: GLuint = 0
    private var vertData: [GLfloat]
    
    init (v: [GLfloat]) {
        vertData = v
    
        glGenVertexArraysOES(1, &VAO)
        glBindVertexArrayOES(VAO)
        
        glGenBuffers(1, &VBO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<GLfloat>.size * vertData.count), &vertData, GLenum(GL_STATIC_DRAW))
        
        // Position Attrib
        glEnableVertexAttribArray   (GLuint(GLKVertexAttrib.position.rawValue))
        glVertexAttribPointer       (GLuint(GLKVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, nil)
        
        // Normal Attrib
        glEnableVertexAttribArray   (GLuint(GLKVertexAttrib.normal.rawValue))
        glVertexAttribPointer       (GLuint(GLKVertexAttrib.normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, BUFFER_OFFSET(12))
        
        glBindVertexArrayOES(0)
    }
    
    deinit {
        glDeleteBuffers(1, &VBO)
        glDeleteVertexArraysOES(1, &VAO)
    }
    
    func bind () {
        glBindVertexArrayOES(VAO)
    }
}
