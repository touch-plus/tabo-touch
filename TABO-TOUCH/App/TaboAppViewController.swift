//
//  TaboViewController.swift
//  TABO-TOUCH
//
//  Created by Michiyasu Wada on 2017/09/06.
//  Copyright © 2017年 Michiyasu Wada. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class TaboAppViewController: UIViewController
{
    
    public var appDisplay:TaboAppDisplay!
    public var appControl:IAppControl?
    public var touchEventControl:TaboTouchEventControl!
    private var _frames:Int = 0
    private var _gesture:UITapGestureRecognizer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        DeviceInfo.info.orientation = .portrait
        DeviceInfo.info.update()
        
        view.tag = 0
        view.isMultipleTouchEnabled = true
        view.backgroundColor = UIColor.black

        TABO.setup(
            TABOCMD(),
            view: self.view,
            uiPosition: CGPoint(x: DeviceInfo.info.width / 2, y: DeviceInfo.info.height / 2),
            landscape: false
        )

        let scnView:SCNView = self.view as! SCNView
        
        appDisplay = TaboAppDisplay(view:scnView)
        appDisplay.info()

        touchEventControl = TaboTouchEventControl(view:scnView)
        touchEventControl.didReset = reset

        _ = setInterval(1.0 / AppConfig.FPS, block:enterFrame)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        removeGestureRecognizers()
    }
    
    private func removeGestureRecognizers()
    {
        let window = view.window!
        for gesture:UIGestureRecognizer in window.gestureRecognizers!
        {
            window.removeGestureRecognizer(gesture)
        }
        if self.view.gestureRecognizers != nil
        {
            for gesture:UIGestureRecognizer in self.view.gestureRecognizers!
            {
                self.view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    
    func reset()
    {
        if appControl != nil
        {
            appControl?.reset()
        }
    }
    
    func enterFrame()
    {
        touchEventControl.frameNext()
        appUpdate(touchEventControl.allTouches)
    }
    
    func appUpdate(_ touches: Set<UITouch>)
    {
        if appControl == nil { return }
//        if touches == nil { return }
        if _frames == touchEventControl.frames { return }
        
        _frames = touchEventControl.frames
        appControl?.update(frames: touchEventControl.frames, touches:touches)
    }
    
    
    //------------------------------------------------------------------------------------- touch event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        touchEventControl.touchesBegan(touches, with: event)
        appUpdate(touchEventControl.allTouches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesMoved(touches, with: event)
        touchEventControl.touchesMoved(touches, with: event)
        appUpdate(touchEventControl.allTouches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        touchEventControl.touchesEnded(touches, with: event)
        appUpdate(touchEventControl.allTouches)
    }
    
    //------------------------------------------------------------------------------------- app settings
    
    override var shouldAutorotate: Bool
    {
        return true
    }

    override var prefersStatusBarHidden: Bool
    {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .portrait
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
