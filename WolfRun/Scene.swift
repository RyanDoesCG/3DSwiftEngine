//
//  Scene.swift
//  WolfRun
//
//  Created by user on 13/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

import GLKit

class Scene {
    private var actors: [Actor]!
    private var camera: Camera = Camera ()
    private var width: Float
    private var height: Float
    
    init (w: Float, h: Float) {
        actors = [Actor]()
        width = w
        height = h
    }
    
    func getProjectionMatrix () -> GLKMatrix4 { return camera.getProjectionMatrix() }
    
    func add (new: Actor) { actors.append(new) }
    
    func simulate () {
        actors.forEach { $0.update() }
    }
    
    func draw () {
        camera.update(width: width, height: height)
        actors.forEach { $0.draw(camera: camera) }
    }
}
