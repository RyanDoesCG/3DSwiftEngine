/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  GameViewController.swift
 *  WolfRun
 *
 *  Created by Ryan Needham on 13/02/2017.
 *  Copyright © 2017 Baked Goods Studios. All rights reserved.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
import GLKit
import OpenGLES
import SwiftMath

func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer {return UnsafeRawPointer(bitPattern: i)!}

class GameViewController: GLKViewController {

    var clearColour: Vec3 = Vec3(x: 0.8, y: 0.8, z: 0.8)
    var context: EAGLContext?   = nil
    var effect:  GLKBaseEffect? = nil
    
    var scene: Scene!
    
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
        
        self.setupGL()
        
        /* * * * * * * * * * *
         *  populate scene
         */
         let cube1 = Player()
         let cube2 = Cube()
         let plane = Plane(w: 10, h: 10)
        
         cube1.position.z = -6
         cube1.position.x = -1.5
         cube1.colour = Vec4(r: 0.21, g: 0.21, b: 0.21, a: 1.0)
         cube1.twirling = true

         cube2.position.z = -6
         cube2.position.x = 1.5
         cube2.colour = Vec4(r: 0.21, g: 0.21, b: 0.42, a: 1.0)
         cube2.twirling = true
        
         plane.position.y = -6
         plane.position.z = -6
         plane.position.x = 0
        
        
         scene = Scene(w: Float(self.view.bounds.size.width), h: Float(self.view.bounds.size.height))
        // scene.add(new: cube1)
        // scene.add(new: cube2)
         scene.add(new: plane)
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
        
        scene.simulate()

    }
    
    /* * * * * * * * * * * * * * * * * * * * *
     *  DRAW SCENE
     * * * * * * * * * * * * * * * * * * * * */
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(clearColour.x, clearColour.y, clearColour.z, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        scene.draw()
    }
}
