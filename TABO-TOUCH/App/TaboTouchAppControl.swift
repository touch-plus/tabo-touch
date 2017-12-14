//
//  FreeDriveControl.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/08.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import Foundation

import UIKit
import QuartzCore
import SceneKit

class TaboTouchAppControl:IAppControl, TaboControlDelegate
{
    private var _positionManager:TaboPositionManager!
    private var _display:TaboTouchDisplay!
    private var _tabo:TABO!
    private var _view:SCNView!
    private var _spot:TaboSpotView!
    private var _target:CGPoint!
    private var _moving:Bool = false
    private var _updateTime:TimeInterval = 0
    
    init(appDisplay:TaboAppDisplay)
    {
        _view = appDisplay.scnView
        _positionManager = TaboPositionManager(view: _view)
        _display = TaboTouchDisplay(screen: appDisplay.screen)
        
        _spot = TaboSpotView()
        appDisplay.screen.addChildNode(_spot)
        _spot.setup()
        _spot.show()
        
        reset()
    }
    
    
    deinit {}
    
    
    public func reset()
    {
        if _tabo != nil
        {
            _tabo.control.disconnect()
            _tabo = nil
            _moving = false
            _target = nil
            _display.reset()
        }
    }
    
    public func update(frames:Int, touches:Set<UITouch>)
    {
        let positions:[TaboLocation] = _positionManager.update(touches)
        if _tabo == nil
        {
            checkConnect(positions)
        }
        else
        {
            taboPositionUpdate(positions)
            taboCommandUpdate()
        }
        _display.update(frames)
    }
    
    public func move(to touches: Set<UITouch>) -> Bool
    {
        if let touch:UITouch = touches.first
        {
            return move(to: touch)
        }
        return false
    }
    
    public func move(to touch: UITouch) -> Bool
    {
        let point:CGPoint = touch.location(in: _view)
        return move(to: point)
    }
    
    public func move(to point: CGPoint) -> Bool
    {
        if _tabo == nil { return false }
        
        let x:Float = Float(_tabo.position.x - point.x)
        let y:Float = Float(_tabo.position.y - point.y)
        let distance:Float = sqrt(x*x+y*y)
        if distance < DisplayUtil.mm2pixel(AppConfig.MIN_NEAR_LENGTH)
        {
            return false
        }
        _target = point
        _display.addTouchMarker(_target)
        return true
    }
    
    public func addMark(touch:UITouch)
    {
        let pt:CGPoint = touch.location(in: _view)
        _display.addTouchMarker(pt)
    }
    
    public func addMarks(touches:Set<UITouch>?)
    {
        if let list:Set<UITouch> = touches
        {
            for touch:UITouch in list
            {
                self.addMark(touch: touch)
            }
        }
    }
    
    private func taboCommandUpdate()
    {
        var cmd:String!
        var led:LED!
        let tx:CGFloat = _tabo.position.x
        let ty:CGFloat = _tabo.position.y
        let space:CGFloat = AppConfig.SIDE_SPACE
        if tx < space || tx > DeviceInfo.info.width - space || ty < space || ty > DeviceInfo.info.height - space
        {
            led = LED(red: 0.5, green: 0.5, blue: 0.5)
            cmd = TABO.command.move.directLED(left: 0, right: 0, led: led)
            _tabo.leftWheel = 0
            _tabo.rightWheel = 0
            _tabo.send(cmd)
            _moving = false
            return
        }
        
        if let pt:CGPoint = _target
        {
            let x:Float = Float(pt.x - tx)
            let y:Float = Float(pt.y - ty)
            let distance:Float = sqrt(x*x + y*y)
            let angle:Float = atan2(y, x) - _tabo.angle + PI
            let rotate:Float = atan2(sin(angle), cos(angle)) / PI * 2
            let speed:Float = AppConfig.SPEED
            let range:Float = 60
            if distance > range
            {
                let r:Float = 0.75 // 逆回転の補正値（0.5〜1.0）少ないほど回転が大回りになる
                var scale:Float = distance / AppConfig.DECELERATE_LENGTH
                if scale > 1
                {
                    scale = 1
                }
                
                if rotate > 0
                {
                    //右旋回
                    _tabo.leftWheel = scale
                    _tabo.rightWheel = (1 - rotate * r) * scale
                }
                else if rotate < 0
                {
                    //左旋回
                    _tabo.leftWheel = (1 - (-rotate * r)) * scale
                    _tabo.rightWheel = scale
                }
                else
                {
                    _tabo.leftWheel = scale
                    _tabo.rightWheel = scale
                }
                
                _tabo.leftWheel  *= _tabo.leftWheelMultiple
                _tabo.rightWheel *= _tabo.rightWheelMultiple
                _tabo.leftWheel  *= _tabo.speedMultiple
                _tabo.rightWheel *= _tabo.speedMultiple
                _tabo.leftWheel  *= speed
                _tabo.rightWheel *= speed
                _moving = true
            }
            else
            {
                _moving = false
                _tabo.leftWheel = 0
                _tabo.rightWheel = 0
            }
            led = LED(red: 1, green: 1, blue: 1)
            cmd = TABO.command.move.directLED(left: _tabo.leftWheel, right: _tabo.rightWheel, led: led)
            _tabo.send(cmd)
        }
    }
    
    private func taboPositionUpdate(_ positions:[TaboLocation])
    {
        let _now:TimeInterval = now()
        for loc:TaboLocation in positions
        {
            var pt:CGPoint = CGPoint(
                x:(loc.a.x + loc.b.x + loc.c.x) / 3,
                y:(loc.a.y + loc.b.y + loc.c.y) / 3)
            pt.x = pt.x + (loc.a.x - pt.x) * 0.3
            pt.y = pt.y + (loc.a.y - pt.y) * 0.3
            let angle:Float = Float(atan2(pt.y - loc.a.y, pt.x - loc.a.x))
            _tabo.angle = angle
            _tabo.position = pt
            break
        }
        if positions.count == 0
        {
            if _updateTime == 0
            {
                _updateTime = _now
                return
            }
            let time:TimeInterval = _now - _updateTime
            let L:CGFloat = DisplayUtil.mm2pixel(CGFloat(_tabo.leftWheel * Float(time))) * CGFloat(TABO.command.core.scale()) * 0.5
            let R:CGFloat = DisplayUtil.mm2pixel(CGFloat(_tabo.rightWheel * Float(time))) * CGFloat(TABO.command.core.scale()) * 0.5
            let radius:CGFloat = DisplayUtil.mm2pixel(13.5)
            let LP:CGPoint = CGPoint(x:-radius, y:L)
            let RP:CGPoint = CGPoint(x:radius, y:R)
            let distance:CGFloat = (L+R)/2
            let angle:CGFloat = atan2(RP.y-LP.y, RP.x-LP.x)
            _tabo.angle -= Float(angle)
            _tabo.position.x += CGFloat(cos(_tabo.angle + Float.pi)) * distance
            _tabo.position.y += CGFloat(sin(_tabo.angle + Float.pi)) * distance
        }
        _updateTime = _now
    }
    
    
    
    private func checkConnect(_ positions:[TaboLocation])
    {
//        for _:TaboLocation in positions
//        {
//            connect()
//            break
//        }
        connect()
    }
    
    private func connect()
    {
        print("TABO Scaned")
        
        _tabo = TABO()
        _tabo.delegate += self
        _tabo.connect()
        _display.setup(_tabo)
        
        _spot.on()
    }
    
    //--------------------------------- TaboControlDelegate ---------------------------------
    
    /// 接続通知
    func didConnect()
    {
        print("TABO Connected")
        _tabo.send(TABO.command.led.on())
        
        _spot.hide()
    }
    
    /// 切断通知
    func didDisconnect()
    {
        print("TABO Disconnected")
        reset()
        _spot.off()
        _spot.show()
    }
    
    ///
    func didReceiveCommand( response:String )
    {
        
    }
    
    ///
    func didSendCommand(_ tabo:TABO, _ command:String )
    {
        
    }
    
}
