/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  Actor.swift
 *  WolfRun
 *
 *  Created by Ryan Needham on 13/02/2017.
 *  Copyright © 2017 Baked Goods Studios. All rights reserved.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
import Foundation

protocol Actor {
    var position: Vec3 { get set }
    var velocity: Vec3 { get set }
    
    func update () 
    func draw   (camera: Camera)
}
