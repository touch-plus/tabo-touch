//
//  DeviceModel.swift
//  TABO-TOUCH
//
//  Created by 和田教寧 on 2017/09/14.
//  Copyright © 2017年 Michiyasu Wada. All rights reserved.
//

import UIKit

class DeviceModel
{
    private static let _modelList = [
        "iPod5,1": "iPod Touch 5",
        "iPhone3,1": "iPhone 4",
        "iPhone3,2": "iPhone 4",
        "iPhone3,3": "iPhone 4",
        "iPhone4,1": "iPhone 4S",
        "iPhone5,1": "iPhone 5",
        "iPhone5,2": "iPhone 5",
        "iPhone5,3": "iPhone 5C",
        "iPhone5,4": "iPhone 5C",
        "iPhone6,1": "iPhone 5S",
        "iPhone6,2": "iPhone 5S",
        "iPhone7,2": "iPhone 6",
        "iPhone7,1": "iPhone 6 Plus",
        "iPhone8,1": "iPhone 6S",
        "iPhone8,2": "iPhone 6S Plus",
        "iPhone8,4": "iPhone SE",
        "iPhone9,1": "iPhone 7",
        "iPhone9,3": "iPhone 7",
        "iPhone9,2": "iPhone 7 Plus",
        "iPhone9,4": "iPhone 7 Plus",
        
        "iPad1,1": "iPad",
        "iPad2,1": "iPad 2",
        "iPad2,2": "iPad 2",
        "iPad2,3": "iPad 2",
        "iPad2,4": "iPad 2",
        
        "iPad3,1": "iPad 3",
        "iPad3,2": "iPad 3",
        "iPad3,3": "iPad 3",
        
        "iPad3,4": "iPad 4",
        "iPad3,5": "iPad 4",
        "iPad3,6": "iPad 4",
        
        //    "iPad6,11": "iPad 5",
        //    "iPad6,12": "iPad 5",
        
        "iPad4,1": "iPad Air",
        "iPad4,2": "iPad Air",
        "iPad4,3": "iPad Air",
        "iPad5,3": "iPad Air 2",
        "iPad5,4": "iPad Air 2",
        
        "iPad2,5": "iPad mini",
        "iPad2,6": "iPad mini",
        "iPad2,7": "iPad mini",
        "iPad4,4": "iPad mini 2",
        "iPad4,5": "iPad mini 2",
        "iPad4,6": "iPad mini 2",
        "iPad4,7": "iPad mini 3",
        "iPad4,8": "iPad mini 3",
        "iPad4,9": "iPad mini 3",
        "iPad5,1": "iPad mini 4",
        "iPad5,2": "iPad mini 4",
        
        "iPad6,3": "iPad Pro (9.7-inch)",
        "iPad6,4": "iPad Pro (9.7-inch)",
        "iPad6,11": "iPad Pro (9.7-inch)",
        "iPad6,12": "iPad Pro (9.7-inch)",
        "iPad6,7": "iPad Pro (12.9-inch)",
        "iPad6,8": "iPad Pro (12.9-inch)",
        "iPad7,1": "iPad Pro (12.9-inch)",
        "iPad7,2": "iPad Pro (12.9-inch)",
        "iPad7,3": "iPad Pro (10.5-inch)",
        "iPad7,4": "iPad Pro (10.5-inch)",
        
        "x86_64": "Simulator",
        "i386": "Simulator"
    ]
    
    public static func getName() -> String
    {
        let id = getIdentifier()
        if let name = _modelList[id]
        {
            return name
        }
        return UIDevice.current.name
    }
    
    private static var _identifier:String = ""
    
    public static func getIdentifier() -> String
    {
        if _identifier != ""
        {
            return _identifier
        }
        
        var utdName: utsname = utsname()
        uname(&utdName)
        
        let machine = utdName.machine
        let mirror: Mirror = Mirror(reflecting: machine)
        var identifier: String = ""
        
        for children in mirror.children {
            if let value = children.value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        _identifier = identifier
        return identifier
    }
    
}

