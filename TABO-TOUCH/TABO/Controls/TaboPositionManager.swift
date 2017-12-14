//
//  TouchControl.swift
//  tabo2
//
//  Created by Michiyasu Wada on 2015/12/17.
//  Copyright © 2015年 Michiyasu Wada. All rights reserved.
//

import UIKit
import SceneKit
import Foundation

class TaboPositionManager:TaboControlDelegate
{
    private var _view:SCNView!
    private var _scale:CGFloat = 1
    private var _minRange:CGFloat = 18.0 // 18
    private var _maxRange:CGFloat = 35.0 // 35
    private var _hashDict:[Int] = []
    
    init(view:SCNView, minRange:CGFloat=18, maxRange:CGFloat=35)
    {
        _view = view
        _scale = 1
        _minRange = minRange
        _maxRange = maxRange
    }
    deinit {}
    
    public func isTaboTouch(_ touch: UITouch) -> Bool
    {
        return _hashDict.contains(touch.hash)
    }
    
    public func getOtherTouches(_ touches: Set<UITouch>) -> Set<UITouch>
    {
        var dest:Set<UITouch> = Set<UITouch>()
        for touch:UITouch in touches
        {
            if isTaboTouch(touch) == false
            {
                dest.insert(touch)
            }
        }
        return dest
    }
    
    
    public func update(_ touches:Set<UITouch>) -> [TaboLocation]
    {
        let scale:CGFloat = _scale
        var tmp:[TouchItem] = [TouchItem]()
        var hashes:[String:TouchItem] = [String:TouchItem]()
        var positions:[TaboLocation] = [TaboLocation]()
        let MIN:CGFloat = _minRange
        let MAX:CGFloat = _maxRange
//        print("touch count >>> \(touches.count)")
        
        _hashDict = []
        for touch1:UITouch in touches
        {
            let position1:CGPoint = touch1.preciseLocation(in: _view)
            let x1:CGFloat = DisplayUtil.pixel2mm(position1.x * scale)
            let y1:CGFloat = DisplayUtil.pixel2mm(position1.y * scale)
            
            for touch2:UITouch in touches
            {
                let hash1:String = "\(touch1.hash)_\(touch2.hash)"
                let hash2:String = "\(touch2.hash)_\(touch1.hash)"
                if touch1.hash == touch2.hash { continue }
                if hashes[hash1] != nil { continue }
                if hashes[hash2] != nil { continue }
                
                let position2:CGPoint = touch2.preciseLocation(in: _view)
                let x2:CGFloat = DisplayUtil.pixel2mm(position2.x * scale)
                let y2:CGFloat = DisplayUtil.pixel2mm(position2.y * scale)
                
                let dxA:CGFloat = x1 - x2
                let dyA:CGFloat = y1 - y2
                let lenA:CGFloat = sqrt(dxA*dxA + dyA*dyA)
                if lenA > MIN && lenA < MAX
                {
                    for touch3:UITouch in touches
                    {
                        let hash3:String = "\(touch1.hash)_\(touch3.hash)"
                        let hash4:String = "\(touch3.hash)_\(touch1.hash)"
                        let hash5:String = "\(touch2.hash)_\(touch3.hash)"
                        let hash6:String = "\(touch3.hash)_\(touch2.hash)"
                        if touch1.hash == touch3.hash { continue }
                        if touch2.hash == touch3.hash { continue }
                        if hashes[hash3] != nil { continue }
                        if hashes[hash4] != nil { continue }
                        if hashes[hash5] != nil { continue }
                        if hashes[hash6] != nil { continue }
                        
                        let position3:CGPoint = touch3.preciseLocation(in: _view)
                        let x3:CGFloat = DisplayUtil.pixel2mm(position3.x * scale)
                        let y3:CGFloat = DisplayUtil.pixel2mm(position3.y * scale)
                        
                        let dxB:CGFloat = x1 - x3
                        let dyB:CGFloat = y1 - y3
                        let lenB:CGFloat = sqrt(dxB*dxB + dyB*dyB)
                        
                        if lenB > MIN && lenB < MAX
                        {
                            let dxC:CGFloat = x2 - x3
                            let dyC:CGFloat = y2 - y3
                            let lenC:CGFloat = sqrt(dxC*dxC + dyC*dyC)
                            
//                            print("a:\(lenA), b:\(lenB), c:\(lenC)")
                            
                            if lenC > MIN && lenC < MAX
                            {
                                let itemA = TouchItem()
                                itemA.touch1 = touch1.hash
                                itemA.touch2 = touch2.hash
                                itemA.x1 = position1.x
                                itemA.y1 = position1.y
                                itemA.x2 = position2.x
                                itemA.y2 = position2.y
                                itemA.mmX1 = x1
                                itemA.mmY1 = y1
                                itemA.mmX2 = x2
                                itemA.mmY2 = y2
                                itemA.mmLength = lenA
                                
                                let itemB = TouchItem()
                                itemB.touch1 = touch1.hash
                                itemB.touch2 = touch3.hash
                                itemB.x1 = position1.x
                                itemB.y1 = position1.y
                                itemB.x2 = position3.x
                                itemB.y2 = position3.y
                                itemB.mmX1 = x1
                                itemB.mmY1 = y1
                                itemB.mmX2 = x3
                                itemB.mmY2 = y3
                                itemB.mmLength = lenB
                                
                                let itemC = TouchItem()
                                itemC.touch1 = touch2.hash
                                itemC.touch2 = touch3.hash
                                itemC.x1 = position2.x
                                itemC.y1 = position2.y
                                itemC.x2 = position3.x
                                itemC.y2 = position3.y
                                itemC.mmX1 = x2
                                itemC.mmY1 = y2
                                itemC.mmX2 = x3
                                itemC.mmY2 = y3
                                itemC.mmLength = lenC
                                
                                tmp.append(itemA)
                                tmp.append(itemB)
                                tmp.append(itemC)
                                hashes[hash1] = itemA
                                hashes[hash3] = itemB
                                hashes[hash5] = itemC
                                
                                let _min = min(lenA, lenB, lenC)
                                var ptA:CGPoint!
                                var ptB:CGPoint!
                                var ptC:CGPoint!
                                switch _min {
                                case lenA:
                                    ptA = position3
                                    // ∧ 1-3-2
                                    let r:CGFloat = innerAngle(a: position3, b:position1, c:position2)
                                    if r < 0
                                    {
                                        ptB = position1
                                        ptC = position2
                                    }
                                    else
                                    {
                                        ptB = position2
                                        ptC = position1
                                    }
                                    break
                                case lenB:
                                    ptA = position2
                                    // ∧ 1-2-3
                                    let r:CGFloat = innerAngle(a: position2, b:position1, c:position3)
                                    if r < 0
                                    {
                                        ptB = position1
                                        ptC = position3
                                    }
                                    else
                                    {
                                        ptB = position3
                                        ptC = position1
                                    }
                                    break
                                default:
                                    ptA = position1
                                    // ∧ 2-1-3
                                    let r:CGFloat = innerAngle(a: position1, b:position2, c:position3)
                                    if r < 0
                                    {
                                        ptB = position2
                                        ptC = position3
                                    }
                                    else
                                    {
                                        ptB = position3
                                        ptC = position2
                                    }
                                    break
                                }
                                _hashDict.append(touch1.hash)
                                _hashDict.append(touch2.hash)
                                _hashDict.append(touch3.hash)
                                let id:String = String(touch1.hash)
                                positions.append(TaboLocation(id:id, a:ptA, b:ptB, c:ptC))
                            }
                        }
                    }
                }
            }
        }
        return positions
    }
    
    private func innerAngle(a:CGPoint, b:CGPoint, c:CGPoint) -> CGFloat
    {
        let r1:CGFloat = atan2(b.y - a.y, b.x - a.x)
        let r2:CGFloat = atan2(c.y - a.y, c.x - a.x)
        let rs:CGFloat = r1 - r2
        let r:CGFloat = atan2(sin(rs), cos(rs))
        return r
    }
    
    /// 接続通知
    internal func didConnect()
    {
        
    }
    /// 切断通知
    internal func didDisconnect()
    {
        
    }
    ///
    internal func didReceiveCommand( response:String )
    {
        
    }
    ///
    internal func didSendCommand(_ tabo:TABO, _ command:String )
    {
//        if let pt:CGPoint = parseCommand(command)
//        {
//            tabo.leftWheel = Float(pt.x)
//            tabo.rightWheel = Float(pt.y)
//        }
    }
    
    private func parseCommand(_ cmd:String) -> CGPoint?
    {
        let cmd2 = cmd.split(separator: ":")
        let cmdName:String = String(cmd2[0])
        let cmdParam:String = String(cmd2[1])
        if cmdName == "MDD" || cmdName == "BDL"
        {
            let params = cmdParam.split(separator: ",")
            let left:CGFloat = DisplayUtil.mm2pixel(CGFloat(Float(params[0])!))
            let right:CGFloat = DisplayUtil.mm2pixel(CGFloat(Float(params[1])!))
            return CGPoint(x:left, y:right)
        }
        return nil
    }
}

class TouchItem
{
    var touch1:Int = 0
    var touch2:Int = 0
    var x1:CGFloat = 0.0
    var y1:CGFloat = 0.0
    var x2:CGFloat = 0.0
    var y2:CGFloat = 0.0
    var mmLength:CGFloat = 0.0
    var mmX1:CGFloat = 0.0
    var mmY1:CGFloat = 0.0
    var mmX2:CGFloat = 0.0
    var mmY2:CGFloat = 0.0
    var mmX:CGFloat = 0.0
    var mmY:CGFloat = 0.0
    
    init() {}
    deinit {}
}


