//
//  Timer.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/08.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import Foundation

/**
 * let handle = setTimeout(0.35, block: { () -> Void in
 *     // do this stuff after 0.35 seconds
 * })
 *
 * // Later on cancel it
 * handle.invalidate()
 */
func setTimeout(_ delay:TimeInterval, block:@escaping ()->Void) -> Timer
{
    return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
}

func setInterval(_ interval:TimeInterval, block:@escaping ()->Void) -> Timer
{
    return Timer.scheduledTimer(timeInterval: interval, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: true)
}

func rand(n:Float) -> Float
{
    return Float(arc4random_uniform(360)) / 360.0 * n
}

let PI:Float = 3.14159265358979
let PI2:Float = 3.14159265358979 / 2

func now() -> TimeInterval
{
    return NSDate().timeIntervalSince1970
}

