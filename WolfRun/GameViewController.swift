/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  GameViewController.swift
 *  WolfRun
 *
 *  Created by Ryan Needham on 13/02/2017.
 *  Copyright © 2017 Baked Goods Studios. All rights reserved.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
import GLKit
import OpenGLES
import CoreMotion

func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer {return UnsafeRawPointer(bitPattern: i)!}

let UNIFORM_MODELVIEWPROJECTION_MATRIX = 0
let UNIFORM_NORMAL_MATRIX              = 1
var uniforms = [GLint](repeating: 0, count: 2)

class GameViewController: GLKViewController {

    var clearColour: Vec3 = Vec3(x: 0.8, y: 0.8, z: 0.8)
    
    var shader: ShaderProgram!
    var mesh:   Mesh!
    
    var modelViewProjectionMatrix:GLKMatrix4 = GLKMatrix4Identity
    var normalMatrix: GLKMatrix3 = GLKMatrix3Identity
    var rotation: Float = 0.0
    
    var context: EAGLContext? = nil
    var effect: GLKBaseEffect? = nil
    
    // GAMEPLAY
    var motionManager   = CMMotionManager()
    
    deinit {
        self.tearDownGL()
        
        if EAGLContext.current() === self.context {
            EAGLContext.setCurrent(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = EAGLContext(api: .openGLES2)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        
        motionManager.startAccelerometerUpdates()
        
        self.setupGL()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded && (self.view.window != nil) {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.current() === self.context {
                EAGLContext.setCurrent(nil)
            }
            self.context = nil
        }
    }
    
    /* * * * * * * * * * * * * * * * * * * * *
     *  SETUP OPENGL ES
     * * * * * * * * * * * * * * * * * * * * */
    func setupGL() {
        EAGLContext.setCurrent(self.context)
        
        shader = ShaderProgram(path: "Shader")
        
        self.effect = GLKBaseEffect()
        self.effect!.light0.enabled = GLboolean(GL_TRUE)
        self.effect!.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0)
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
        mesh = Mesh(v: cube)
    }
    
    /* * * * * * * * * * * * * * * * * * * * *
     *  DESTROY OPENGL ES
     * * * * * * * * * * * * * * * * * * * * */
    func tearDownGL() {
        EAGLContext.setCurrent(self.context)
        self.effect = nil
    }

    /* * * * * * * * * * * * * * * * * * * * *
     *  UPDATE
     * * * * * * * * * * * * * * * * * * * * */
    func update() {
        let aspect = fabsf(Float(self.view.bounds.size.width / self.view.bounds.size.height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
        
        self.effect?.transform.projectionMatrix = projectionMatrix
        
        var baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -4.0)
        baseModelViewMatrix     = GLKMatrix4Rotate(baseModelViewMatrix, rotation, 0.0, 1.0, 0.0)
        
        // Compute the model view matrix for the object rendered with ES2
        var modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, 0.0)
        modelViewMatrix     = GLKMatrix4Rotate(modelViewMatrix, rotation, 0.0, 1.0, 0.0)
        modelViewMatrix     = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix)
        
        normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), nil)
        
        modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix)

        // Process Input
        processMotion()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(clearColour.x, clearColour.y, clearColour.z, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        mesh.bind()
        shader.bind()
        
        withUnsafePointer(to: &modelViewProjectionMatrix, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, $0)
            })
        })
        
        withUnsafePointer(to: &normalMatrix, {
            $0.withMemoryRebound(to: Float.self, capacity: 9, {
                glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, $0)
            })
        })
        
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)
    }

    func processMotion() {
        if let data = motionManager.accelerometerData {
            rotation = Float(data.acceleration.x * -0.6)
        }
    }
}

var cube: [GLfloat] = [
    0.5, -0.5, -0.5,        1.0, 0.0, 0.0,
    0.5,  0.5, -0.5,        1.0, 0.0, 0.0,
    0.5, -0.5,  0.5,        1.0, 0.0, 0.0,
    0.5, -0.5,  0.5,        1.0, 0.0, 0.0,
    0.5,  0.5, -0.5,        1.0, 0.0, 0.0,
    0.5,  0.5,  0.5,        1.0, 0.0, 0.0,
    
     0.5, 0.5, -0.5,        0.0, 1.0, 0.0,
    -0.5, 0.5, -0.5,        0.0, 1.0, 0.0,
     0.5, 0.5,  0.5,        0.0, 1.0, 0.0,
     0.5, 0.5,  0.5,        0.0, 1.0, 0.0,
    -0.5, 0.5, -0.5,        0.0, 1.0, 0.0,
    -0.5, 0.5,  0.5,        0.0, 1.0, 0.0,
    
    -0.5,  0.5, -0.5,      -1.0, 0.0, 0.0,
    -0.5, -0.5, -0.5,      -1.0, 0.0, 0.0,
    -0.5,  0.5,  0.5,      -1.0, 0.0, 0.0,
    -0.5,  0.5,  0.5,      -1.0, 0.0, 0.0,
    -0.5, -0.5, -0.5,      -1.0, 0.0, 0.0,
    -0.5, -0.5,  0.5,      -1.0, 0.0, 0.0,
    
    -0.5, -0.5, -0.5,       0.0, -1.0, 0.0,
     0.5, -0.5, -0.5,       0.0, -1.0, 0.0,
    -0.5, -0.5,  0.5,       0.0, -1.0, 0.0,
    -0.5, -0.5,  0.5,       0.0, -1.0, 0.0,
     0.5, -0.5, -0.5,       0.0, -1.0, 0.0,
     0.5, -0.5,  0.5,       0.0, -1.0, 0.0,
    
     0.5,  0.5, 0.5,        0.0, 0.0, 1.0,
    -0.5,  0.5, 0.5,        0.0, 0.0, 1.0,
     0.5, -0.5, 0.5,        0.0, 0.0, 1.0,
     0.5, -0.5, 0.5,        0.0, 0.0, 1.0,
    -0.5,  0.5, 0.5,        0.0, 0.0, 1.0,
    -0.5, -0.5, 0.5,        0.0, 0.0, 1.0,
    
     0.5, -0.5, -0.5,       0.0, 0.0, -1.0,
    -0.5, -0.5, -0.5,       0.0, 0.0, -1.0,
     0.5,  0.5, -0.5,       0.0, 0.0, -1.0,
     0.5,  0.5, -0.5,       0.0, 0.0, -1.0,
    -0.5, -0.5, -0.5,       0.0, 0.0, -1.0,
    -0.5,  0.5, -0.5,       0.0, 0.0, -1.0
]
