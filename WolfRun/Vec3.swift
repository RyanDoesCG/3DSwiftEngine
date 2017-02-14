/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  Vec3.swift
 *  WolfRun
 *
 *  Created by Ryan Needham on 13/02/2017.
 *  Copyright © 2017 Baked Goods Studios. All rights reserved.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
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
    
    func mul (factor: Float) {
        self.x *= factor
        self.y *= factor
        self.z *= factor
    }
    
    func div (factor: Float) {
        if (factor != 0) {
            self.x = self.x / factor
            self.y = self.y / factor
            self.z = self.z / factor
        }
    }
    
    func normalise () {
        let mag = magnitude()
        if (mag != 0) {
            div(factor: mag)
        }
    }
    
    func magnitude () -> Float {
        return sqrt((self.x * self.x) +
                    (self.y * self.y) +
                    (self.z * self.z))
    }
}
