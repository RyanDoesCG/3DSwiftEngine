/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  ShaderProgram.swift
 *  WolfRun
 *
 *  Created by Ryan Needham on 13/02/2017.
 *  Copyright © 2017 Baked Goods Studios. All rights reserved.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
import OpenGLES
import GLKit

class Shader {
    private var programID: GLuint!
    private var vertID:    GLuint = 0
    private var fragID:    GLuint = 0
    
    init (path: String) {
        
        // Create Program
        programID = glCreateProgram()
        
        // Compile Shaders
        let vertShaderPathname = Bundle.main.path(forResource: path, ofType: "vert")!
        if !self.compile(&vertID, type: GLenum(GL_VERTEX_SHADER), file: vertShaderPathname) {
            print("Failed to compile vertex shader")
            return;
        }
        
        let fragShaderPathname = Bundle.main.path(forResource: path, ofType: "frag")!
        if !self.compile(&fragID, type: GLenum(GL_FRAGMENT_SHADER), file: fragShaderPathname) {
            print("Failed to compile fragment shader")
            return;
        }
        
        // Attach Shaders
        glAttachShader(programID, vertID);
        glAttachShader(programID, fragID);
        
        // Identify Attributes
        glBindAttribLocation(programID, GLuint(GLKVertexAttrib.position.rawValue), "position")
        glBindAttribLocation(programID, GLuint(GLKVertexAttrib.normal.rawValue), "normal")
        
        // Link
        if !self.link (programID) {
            print("Failed to link program: \(programID)")
            
            if vertID != 0 {
                glDeleteShader(vertID)
                vertID = 0
            }
            if fragID != 0 {
                glDeleteShader(fragID)
                fragID = 0
            }
            if programID != 0 {
                glDeleteProgram(programID)
                programID = 0
            }
        }
        
        // Release vertex and fragment shaders
        if vertID != 0 {
            glDetachShader(programID, vertID)
            glDeleteShader(vertID)
        }
        if fragID != 0 {
            glDetachShader(programID, fragID)
            glDeleteShader(fragID)
        }
    }
    
    deinit {
        if programID != 0 {
            glDeleteProgram(programID)
            programID = 0
        }
    }
    
    func compile (_ shader: inout GLuint, type: GLenum, file: String) -> Bool {
        var status: GLint = 0
        var source: UnsafePointer<Int8>
        do {
            source = try NSString(contentsOfFile: file, encoding: String.Encoding.utf8.rawValue).utf8String!
        } catch {
            print("Failed to load vertex shader")
            return false
        }
        var castSource: UnsafePointer<GLchar>? = UnsafePointer<GLchar>(source)
        
        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            glDeleteShader(shader)
            return false
        }
        return true
    }
    
    func link (_ prog: GLuint) -> Bool {
        var status: GLint = 0
        glLinkProgram(prog)
        
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            return false
        }
        
        return true
    }
    
    func getProgramID () -> GLuint {
        return programID
    }
    
    func bind () {
        glUseProgram(programID)
    }
}
