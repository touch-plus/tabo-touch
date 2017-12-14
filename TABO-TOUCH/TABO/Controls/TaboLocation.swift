//
//  TaboLocation.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/08.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import Foundation

import UIKit
import Foundation
import SceneKit

class TaboLocation
{
    var id:String = ""
    var a:CGPoint!
    var b:CGPoint!
    var c:CGPoint!
    var va1:SCNVector3?
    var va2:SCNVector3?
    var vb1:SCNVector3?
    var vb2:SCNVector3?
    var vc1:SCNVector3?
    var vc2:SCNVector3?
    var angle:CGFloat = 0.0
    var length:CGFloat = 0.0
    
    init(id:String, a:CGPoint, b:CGPoint, c:CGPoint)
    {
        self.id = id
        self.a = CGPoint(x:a.x, y:a.y)
        self.b = CGPoint(x:b.x, y:b.y)
        self.c = CGPoint(x:c.x, y:c.y)
        self.angle = atan2(a.y - (b.y + c.y) * 0.5, a.x - (b.x + c.x) * 0.5)
    }
    deinit {}
    
    func clone() -> TaboLocation
    {
        let position:TaboLocation = TaboLocation(id:id, a:a, b:b, c:c)
        if va1 != nil { position.va1 = SCNVector3(va1!.x, va1!.y, va1!.z) }
        if va2 != nil { position.va2 = SCNVector3(va2!.x, va2!.y, va2!.z) }
        if vb1 != nil { position.vb1 = SCNVector3(vb1!.x, vb1!.y, vb1!.z) }
        if vb2 != nil { position.vb2 = SCNVector3(vb2!.x, vb2!.y, vb2!.z) }
        if vc1 != nil { position.vc1 = SCNVector3(vc1!.x, vc1!.y, vc1!.z) }
        if vc2 != nil { position.vc2 = SCNVector3(vc2!.x, vc2!.y, vc2!.z) }
        position.angle = angle
        position.length = length
        return position
    }
}

