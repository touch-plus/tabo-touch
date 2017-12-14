//
//  TaboActionCore.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/28.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import UIKit

public class TaboActionCore
{
    
    public let RED:LED   = LED(red: 1, green: 0, blue: 0)
    public let GREEN:LED = LED(red: 0, green: 1, blue: 0)
    public let BLUE:LED  = LED(red: 0, green: 0, blue: 1)
    
    public let ON:LED    = LED(red: 1, green: 1, blue: 1)
    public let OFF:LED   = LED(red: 0, green: 0, blue: 0)
    
    public func RGB(_ red:Float, _ green:Float, _ blue:Float) -> LED
    {
        return LED(red: red, green: green, blue: blue)
    }
    
    var control:TaboControl!
    var ignoreCommand:Bool = false
    var connected:Bool = false
    var _led:LED = LED(red: 1, green: 1, blue: 1)
    
    init(control:TaboControl)
    {
        self.control = control
    }
    
    private var queue:Queue!
    public func clear()
    {
        queue = Queue()
    }
    public func sleep(_ time:TimeInterval)
    {
        queue.sleep(time)
    }
    public func led(_ value:LED)
    {
        queue.append({ (queue:Queue) in
            self._led = value
            self.control.next(TABO.command.led.rgb(red: self._led.red, green: self._led.green, blue: self._led.blue))
            queue.next()
        })
    }
    public func led(_ value:Float)
    {
        queue.append({ (queue:Queue) in
            self._led = LED(red: value, green: value, blue: value)
            self.control.next(TABO.command.led.rgb(red: value, green: value, blue: value))
            queue.next()
        })
    }
    public func led(red:Float, green:Float, blue:Float)
    {
        queue.append({ (queue:Queue) in
            self._led = LED(red: red, green: green, blue: blue)
            self.control.next(TABO.command.led.rgb(red: red, green: green, blue: blue))
            queue.next()
        })
    }
    public func move(_ left:Float, _ right:Float)
    {
        queue.append({ (queue:Queue) in
            self.control.next(TABO.command.move.directLED(left: left, right: right, led: self._led.getColor()))
            queue.next()
        })
    }
    public func move(_ left:Float, _ right:Float, led:LED)
    {
        queue.append({ (queue:Queue) in
            self.control.next(TABO.command.move.directLED(left: left, right: right, led: led.getColor()))
            queue.next()
        })
    }
    public func stop()
    {
        queue.append({ (queue:Queue) in
            self.control.next(TABO.command.move.directLED(left: 0, right: 0, led: self._led.getColor()))
            queue.next()
        })
    }
    public func lock()
    {
        queue.append({ (queue:Queue) in
            self.ignoreCommand = true
            queue.next()
        })
    }
    public func unlock()
    {
        queue.append({ (queue:Queue) in
            self.ignoreCommand = false
            queue.next()
        })
    }
    public func call(_ callback:@escaping ()->Void)
    {
        queue.append(callback)
    }
    public func didConnect()
    {
        queue.append({ (queue:Queue) in
            self.connected = true
            queue.next()
        })
    }
    public func didDisconnect()
    {
        queue.append({ (queue:Queue) in
            self.connected = false
            queue.next()
        })
    }
    
    public func start()
    {
        queue.run()
    }
    
}

