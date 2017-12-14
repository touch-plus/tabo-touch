//
//  TaboTouchEventControl.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/08.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class TaboTouchEventControl
{
    var frames:Int = 0
    var allTouches:Set<UITouch>!
    var tapFrame:Int = 0
    var tapCount:Int = 0
    var tapPoint:CGPoint = CGPoint(x:0, y:0)
    var view:SCNView!
    var didReset: (()->())?
    
    
    init(view:SCNView)
    {
        self.view = view
        reset()
    }
    
    func reset()
    {
        frames = 0
        allTouches = Set<UITouch>()
        
        if let onReset:()->Void = self.didReset
        {
            onReset()
        }
    }
    
    func frameNext()
    {
        frames += 1
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let allTouches = event?.allTouches
        {
            self.allTouches = allTouches
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let allTouches = event?.allTouches
        {
            self.allTouches = allTouches
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        var replaceTouches:Set<UITouch> = Set<UITouch>()
        if let allTouches:Set<UITouch> = event?.allTouches
        {
            for touch:UITouch in allTouches
            {
                var hasHash:Bool = false
                for removedTouch:UITouch in touches
                {
                    if removedTouch.hash == touch.hash
                    {
                        hasHash = true
                        break
                    }
                }
                if hasHash == false
                {
                    replaceTouches.insert(touch)
                }
            }
            self.allTouches = replaceTouches
        }
    }

}
