//
//  LED.swift
//  TABO-TOUCH
//
//  Created by 和田教寧 on 2017/09/07.
//  Copyright © 2017年 Michiyasu Wada. All rights reserved.
//

import Foundation

public class LED
{
    
    public var red:Float = 0
    public var green:Float = 0
    public var blue:Float = 0
    
    init(red:Float, green:Float, blue:Float)
    {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(value:Float=0)
    {
        self.red = value
        self.green = value
        self.blue = value
    }
    
    public func getColor() -> String
    {
        return _range(self.red) + _range(self.green) + _range(self.blue)
    }
    
    private func _range(_ n:Float) -> String
    {
        let val:Int = Int(n * 9)
        if val < 0
        {
            return "0"
        }
        if val > 9
        {
            return "9"
        }
        return String(val)
    }
}
