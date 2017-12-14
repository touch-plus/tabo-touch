//
//  GameViewController.swift
//  TABO-TOUCH
//
//  Created by Michiyasu Wada on 2017/09/05.
//  Copyright © 2017年 Michiyasu Wada. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: TaboAppViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.appControl = TaboTouchAppControl(appDisplay:self.appDisplay)
    }
    
    
    //------------------------------------------------------------------------------------- touch event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        if let app:IAppControl = self.appControl
        {
            if let touch:UITouch = touches.first
            {
                if app.move(to: touch)
                {
                    app.addMark(touch: touch)
                }
            }
        }
//        self.appControl?.addMarks(touches: touchEventControl.allTouches)
//        self.appControl?.addMarks(touches: touches)
//        self.appControl?.addMark(touch: touches.first!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesMoved(touches, with: event)
//        self.appControl?.addMarks(touches: touchEventControl.allTouches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
//        self.appControl?.addMarks(touches: touchEventControl.allTouches)
//        self.appControl?.addMarks(touches: event?.allTouches)
    }
    
    
}
