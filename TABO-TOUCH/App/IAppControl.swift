//
//  IAppControl.swift
//  TABO-TOUCH
//
//  Created by Michiyasu Wada on 2017/09/05.
//  Copyright © 2017年 Michiyasu Wada. All rights reserved.
//

import UIKit

protocol IAppControl
{
    func reset()
    func update(frames:Int, touches:Set<UITouch>)
    func move(to touches: Set<UITouch>) -> Bool
    func move(to touch: UITouch) -> Bool
    func move(to point: CGPoint) -> Bool
    func addMark(touch:UITouch)
    func addMarks(touches:Set<UITouch>?)
    
    
}
