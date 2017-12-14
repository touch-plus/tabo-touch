//
//  TaboConnectUI.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/18.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class TaboConnectUI
{
    private static var _ui:TaboConnectUI!
    
    public static func getInstance() -> TaboConnectUI
    {
        if _ui == nil
        {
            _ui = TaboConnectUI()
        }
        return _ui
    }
    
    private var _top:CGFloat = 0
    private var _left:CGFloat = 0
    private var _container:UIView!
    private var _pos:CGPoint = CGPoint(x:0, y:0)
    private var _list:[UIView] = [UIView]()
    private var _dict:[String:(()->())] = [:]
    private var _uiContainer:TaboUIContainerView!
    
    private var _landscape:Bool = false
    private var _rotate:CGFloat = 0
    
        
    public func setup(container:UIView, x:CGFloat, y:CGFloat, landscape:Bool = false)
    {
        _container = container
        _landscape = landscape
        _rotate = 0
        if _landscape
        {
            _rotate = CGFloat(Double.pi / 2)
            _top = x + 160
            _left = y
        }
        else
        {
            _top = y + 160
            _left = x
        }
        _uiContainer = TaboUIContainerView(_rotate)
        _container.addSubview(_uiContainer)
        
        clear()
    }

    public func hide()
    {
        _uiContainer.removeFromSuperview()
    }
    
    public func clear()
    {
        for item:UIView in _list
        {
            item.removeFromSuperview()
        }
        _list.removeAll()
        _dict.removeAll()
        _pos.y = _top
        _pos.x = _left
    }
    
    public func addConnect(_ name:String, callback:@escaping ()->Void )
    {
        if _dict[name] != nil
        {
            //登録済みの場合は無視する
            return
        }
        
        addButton(name, #selector(TaboConnectUI.onClickButton))
        _dict[name] = callback
    }
    
    public func removeConnect(_ name:String?)
    {
        for (i, button) in _list.enumerated()
        {
            let _btn:TaboUIConnectButton = button as! TaboUIConnectButton
            if _btn.label == name
            {
                _btn.removeFromSuperview()
                _list.remove(at: i)
                _dict[name!] = nil
                break
            }
        }
        _pos.y = _top
        for button:UIView in _list
        {
            let _btn:TaboUIConnectButton = button as! TaboUIConnectButton
            let frame = _btn.frame
            _btn.frame = CGRect(x: frame.minX, y: _pos.y, width: frame.width, height: frame.height)
            _pos.y += _btn.height + 10
        }
    }
    
    
    @objc internal func onClickButton(_ sender:UIView)
    {
        let button:UIButton = sender as! UIButton
        button.backgroundColor = TaboUIConnectButton.ACTIVE_COLOR
        if let label:String = button.title(for: UIControlState.normal)
        {
            _dict[label]?()
        }
    }
    
    private func addButton(_ label:String, _ listener:Selector)
    {
        if _uiContainer.superview == nil
        {
            _container.addSubview(_uiContainer)
        }
        
        let button:TaboUIConnectButton = TaboUIConnectButton(
                position: _pos,
                label: label)
        button.addTarget(self, action: listener, for: .touchUpInside)
        _uiContainer.addSubview(button)
        _list.append(button)
        _pos.y += button.height + 10
    }
    
}

class TaboUIConnectButton:UIButton
{
    static let ACTIVE_COLOR:UIColor = UIColor(red: 0xef/0xff, green: 0x06/0xff, blue: 0x90/0xff, alpha: 1)
    static let NORMAL_COLOR:UIColor = UIColor(red: 0x3a/0xff, green: 0x3a/0xff, blue: 0x3a/0xff, alpha: 1)
    
    public let width:CGFloat = 160
    public let height:CGFloat = 60
    public var label:String = ""
    
    init(position:CGPoint, label:String)
    {
        super.init(frame: CGRect(
            x:position.x - width/2,
            y:position.y,
            width:width,
            height:height)
        )
        self.label = label
        self.setTitle(label, for: UIControlState.normal)
        self.backgroundColor = TaboUIConnectButton.NORMAL_COLOR
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TaboUIContainerView:UIView
{
    init(_ rotate:CGFloat)
    {
        super.init(frame: CGRect.zero)
        
        self.tag = 100
        self.transform = self.transform.rotated(by: rotate)
        self.frame = CGRect(
            x:0, y:0,
            width:DeviceInfo.info.width,
            height:DeviceInfo.info.height
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
    {
        if let touchView:UIView = super.hitTest(point, with: event)
        {
            if touchView is UIButton { return touchView }
        }
        return nil
    }
}
