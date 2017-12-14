//
//  TABO.swift
//  TaboDemo1
//
//  Created by Michiyasu Wada on 2016/01/07.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import UIKit

class TABO:TaboControlDelegate
{
    private static var _command:TaboCommand!
    private static var _ui:TaboConnectUI!
    
    static var command:TaboCommand!
    {
        get { return _command }
    }
    
    static var ui:TaboConnectUI!
    {
        get { return _ui }
    }
    
    static func setup(_ cmd:TABOCMD, view:UIView, uiPosition:CGPoint? = nil, landscape:Bool = false)
    {
        _command = TaboCommand(cmd:cmd)
        _ui = TaboConnectUI.getInstance()
        _ui.setup(
            container: view,
            x: (uiPosition != nil) ? uiPosition!.x : DeviceInfo.info.width / 2,
            y: (uiPosition != nil) ? uiPosition!.y : DeviceInfo.info.height / 2,
            landscape: landscape
        )
    }
    
    var control:TaboControl!
    var position:CGPoint = CGPoint(x:0, y:0)
    var angle:Float = 0
    var leftWheel:Float = 0
    var rightWheel:Float = 0
    var leftWheelMultiple:Float = 1.0
    var rightWheelMultiple:Float = 1.0
    var speedMultiple:Float = 1.0
    
    private var _action:TaboActionCommand!
    
    public var connected:Bool {
        get { return _action.connected }
    }
    
    public var delegate:TaboControlDelegateList {
        get { return control.delegate }
    }
    
    
    init()
    {
        control = TaboControl(tabo:self)
        control.delegate += self
        if TABO.command.version == "2.0"
        {
            leftWheelMultiple = 1.0
            rightWheelMultiple = 1.0
            speedMultiple = 0.8
        }
        _action = TaboActionCommand(control: self.control)
    }
    
    deinit {}
    
    func connect()
    {
        control.connect()
    }
    
    func send(_ cmd:String)
    {
        if _action.ignoreCommand == false
        {
            control.send(cmd)
        }
    }
    
    func next(_ cmd:String)
    {
        control.next(cmd)
    }
    
    func clear()
    {
        control.clear()
    }
    
    /// 接続通知
    func didConnect()
    {
        _action.test()
    }
    
    
    func blink()
    {
        _action.blink()
    }
    
    func happy(callback: @escaping ()->Void )
    {
        _action.happy(done: callback)
    }
    
    func veryHappy()
    {
        _action.veryHappy()
    }
    
    func angry(callback: @escaping ()->Void )
    {
        _action.angry(done: callback)
    }
    
    func veryAngry()
    {
        _action.veryAngry()
    }
    
    
    /// 切断通知
    func didDisconnect()
    {
        
    }
    
    ///
    internal func didSendCommand(_ tabo:TABO, _ command:String )
    {
        
    }
    
    ///
    func didReceiveCommand( response:String )
    {
        
    }
    
}


