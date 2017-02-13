//
//  Vec3.swift
//  WolfRun
//
//  Created by user on 13/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

import Foundation

class Vec3 {
    public var x: Float = 0;
    public var y: Float = 0;
    public var z: Float = 0;
    
    init (x: Float, y: Float, z: Float) {
        self.x = x;
        self.y = y;
        self.z = z;
    }
    
    func add (other: Vec3) {
        self.x += other.x
        self.y += other.y
        self.z += other.z
    }
    
    func sub (other: Vec3) {
        self.x -= other.x
        self.y -= other.y
        self.z -= other.z
    }
    
    func normalise () {
        
    }
}
