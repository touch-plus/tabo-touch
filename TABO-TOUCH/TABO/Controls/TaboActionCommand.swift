//
//  TaboCustomCommand.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/25.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import UIKit

class TaboActionCommand:TaboActionCore
{
    override init(control:TaboControl)
    {
        super.init(control: control)
    }
    
    func blink()
    {
        clear()
        led(OFF)
        sleep(0.2)
        led(ON)
        sleep(0.2)
        led(OFF)
        sleep(0.2)
        led(ON)
        start()
    }
    
    func happy(done: @escaping ()->Void)
    {
        clear()
        move(0, 0)
        led(RGB(0, 1, 0))
        sleep(0.2)
        led(RGB(1, 1, 0))
        sleep(0.2)
        move(2000, -1200)
        led(RGB(0, 1, 0))
        sleep(0.2)
        led(RGB(1, 1, 0))
        sleep(0.2)
        led(RGB(0, 1, 0))
        sleep(0.2)
        led(RGB(1, 1, 1))
        move(0, 0)
        call(done)
        start()
    }
    
    func veryHappy()
    {
        let delay:TimeInterval = 0.5

        clear()
        lock()
        led(GREEN)
        sleep(0.2)
        for _:Int in 1...2
        {
            move(500, 200)
            sleep(delay)
            move(-500, -200)
            sleep(delay)
            move(200, 500)
            sleep(delay)
            move(-200, -500)
            sleep(delay)
        }
        stop()
        led(OFF)
        unlock()
        start()
    }
    
    func angry(done: @escaping ()->Void)
    {
        let shake:Float = 300
        let time:TimeInterval = 0.2
        
        clear()
        lock()
        led(OFF)
        sleep(0.2)
        led(RED)
        sleep(0.2)
        led(OFF)
        sleep(0.2)
        led(RED)
        for _:Int in 1...4
        {
            sleep(time)
            move(shake, -shake)
            sleep(time)
            move(-shake, shake)
        }
        stop()
        unlock()
        sleep(0.2)
        led(ON)
        call(done)
        start()
        
    }
    
    func veryAngry()
    {
        let shake:Float = 300
        let time:TimeInterval = 0.2
        clear()
        lock()
        led(OFF)
        sleep(0.2)
        led(RED)
        sleep(0.2)
        led(OFF)
        sleep(0.2)
        led(RED)
        for _:Int in 1...12
        {
            sleep(time)
            move(shake, -shake)
            sleep(time)
            move(-shake, shake)
        }
        stop()
        unlock()
        sleep(2.0)
        led(OFF)
        start()
    }
    
    func test()
    {
        clear()
//        sleep(1)
//        led(RED)
//        sleep(1)
//        led(GREEN)
//        sleep(1)
//        led(BLUE)
//        sleep(1)
        led(ON)
//        sleep(0.5)
        didConnect()
        start()
    }

}


