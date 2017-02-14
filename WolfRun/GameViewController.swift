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

let UNIFORM_MODEL = 0
let UNIFORM_VIEW = 1
let UNIFORM_PROJECTION = 2
let UNIFORM_NORMAL_MATRIX = 3
var uniforms = [GLint](repeating: 0, count: 4)

class GameViewController: GLKViewController {

    var clearColour: Vec3 = Vec3(x: 0.8, y: 0.8, z: 0.8)
    
    var scene: Scene!
    var cube: Cube!
    
    var context: EAGLContext?   = nil
    var effect:  GLKBaseEffect? = nil
    
    // GAMEPLAY
    var motionManager = CMMotionManager()
    
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
        
        /* * * * * * * * * * *
         *  populate scene
         */
         cube = Cube()
         scene = Scene(w: Float(self.view.bounds.size.width), h: Float(self.view.bounds.size.height))
         scene.add(new: cube)
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
        
        self.effect = GLKBaseEffect()
        self.effect!.light0.enabled = GLboolean(GL_TRUE)
        self.effect!.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0)
        
        glEnable(GLenum(GL_DEPTH_TEST))
    
    }
    
    /* * * * * * * * * * * * * * * * * * * * *
     *  DESTROY OPENGL ES
     * * * * * * * * * * * * * * * * * * * * */
    func tearDownGL() {
        EAGLContext.setCurrent(self.context)
        self.effect = nil
    }

    /* * * * * * * * * * * * * * * * * * * * *
     *  UPDATE SIMULATION
     * * * * * * * * * * * * * * * * * * * * */
    func update() {
        self.effect?.transform.projectionMatrix = scene.getProjectionMatrix()
        
        
        cube.update()
        
        // Process Input
        processMotion()
    }
    
    /* * * * * * * * * * * * * * * * * * * * *
     *  DRAW SCENE
     * * * * * * * * * * * * * * * * * * * * */
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(clearColour.x, clearColour.y, clearColour.z, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        scene.draw()
    }

    func processMotion() {
       // if let data = motionManager.accelerometerData {
           // rotation += Float(data.acceleration.x * -0.6)
       // }
    }
}
