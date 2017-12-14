//
//  Vector2.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/08.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import Foundation
import SceneKit

class Vector2
{
    var x:Float = 0
    var y:Float = 0
    var angle:Float = 0
    var length:Float = 0
    
    init(x:Float, y:Float)
    {
        self.x = x
        self.y = y
    }
    
    func setVector(vx:Float, vy:Float)
    {
        let tx:Float = x - vx
        let ty:Float = y - vy
        angle = atan2(ty, tx)
        length = sqrt(tx * tx + ty * ty)
    }
    
    deinit{}
    
    func clone() -> Vector2
    {
        return Vector2(x:self.x, y:self.y)
    }
    
    static func fromVector3(v:SCNVector3) -> Vector2
    {
        return Vector2(x:v.x, y:v.y)
    }
}



