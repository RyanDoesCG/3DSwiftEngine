//
//  Player.swift
//  WolfRun
//
//  Created by user on 18/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

import CoreMotion

class Player : Cube {

    private var motionManager = CMMotionManager()
    
    override init () {
        super.init()
        
        motionManager.startAccelerometerUpdates()
    }
    
    override func update () {
        processMotion()
        super.update()
    }
    
    
    func processMotion() {
        if let data = motionManager.accelerometerData {
            rotation.y += Float(data.acceleration.x * -0.6)
        }
    }
}
