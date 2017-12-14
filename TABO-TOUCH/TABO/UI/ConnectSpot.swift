//
//  ConnectSpot.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/08.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class ConnectSpot
{
    var node:SCNNode!
    var view:SCNNode!
    
    private var minX:CGFloat = 0
    private var minY:CGFloat = 0
    private var maxX:CGFloat = 0
    private var maxY:CGFloat = 0
    
    init(x: CGFloat, y: CGFloat, radius: CGFloat)
    {
        let w:CGFloat = DeviceInfo.info.width / 2
        let h:CGFloat = DeviceInfo.info.height / 2
        minX = x - radius + w
        minY = y - radius + h
        maxX = x + radius + w
        maxY = y + radius + h
        
        draw(radius)
    }
    
    func draw(_ radius: CGFloat)
    {
        node = SCNNode()
    }
    
    func remove()
    {
        if self.node != nil
        {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.4
            SCNTransaction.completionBlock = {
                self.node.removeFromParentNode()
                self.node = nil
            }
            self.node.opacity = 0.0
            SCNTransaction.commit()
        }
    }
    
    func hitTest(taboLocation:TaboLocation) -> Bool
    {
        return _hitPoint(taboLocation.a) && _hitPoint(taboLocation.b) && _hitPoint(taboLocation.c)
    }
    
    func _hitPoint(_ pt:CGPoint) -> Bool
    {
        return (minX < pt.x && maxX > pt.x && minY < pt.y && maxY > pt.y)
    }
    
}

