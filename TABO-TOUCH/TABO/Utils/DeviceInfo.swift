//
//  DeviceInfo.swift
//  tabo1
//
//  Created by Michiyasu Wada on 2015/12/16.
//  Copyright © 2015年 Michiyasu Wada. All rights reserved.
//

import UIKit

enum DeviceInfoOrientation
{
    case auto
    case portrait
    case landscape
}

class DeviceInfo
{
    private static var _info:DeviceInfo?
    
    static var info:DeviceInfo
    {
        if _info == nil
        {
            _info = DeviceInfo()
        }
        return _info!
    }
    
    var orientation:DeviceInfoOrientation = .auto // auto, portrait or landscape
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    var scale:CGFloat = 1.0
    var nativeWidth:CGFloat = 0.0
    var nativeHeight:CGFloat = 0.0
    
    var displayWidth_mm:CGFloat = 0.0
    var displayHeight_mm:CGFloat = 0.0
    var displayWidth_inch:CGFloat = 0.0
    var displayHeight_inch:CGFloat = 0.0
    
    var name:String = ""
    var osName:String = ""
    var osVersion:String = ""
    var modelName:String = ""
    var modelID:String = ""
    var ppi:CGFloat = 0.0
    
    init()
    {
        self.update()
    }
    deinit {}
    
    
    public func update()
    {
        let device:UIDevice = UIDevice.current
        
        self.name = device.name
        self.osName = device.systemName
        self.osVersion = device.systemVersion
        
        let mainScreen:UIScreen = UIScreen.main
        let bounds = mainScreen.bounds
        let nativeBounds = mainScreen.nativeBounds
        
        if orientation == .portrait
        {
            self.width = min(bounds.width, bounds.height)
            self.height = max(bounds.width, bounds.height)
            self.nativeWidth = min(nativeBounds.width, nativeBounds.height)
            self.nativeHeight = max(nativeBounds.width, nativeBounds.height)
        }
        else
        if orientation == .landscape
        {
            self.width = max(bounds.width, bounds.height)
            self.height = min(bounds.width, bounds.height)
            self.nativeWidth = max(nativeBounds.width, nativeBounds.height)
            self.nativeHeight = min(nativeBounds.width, nativeBounds.height)
        }
        else
        {
            self.width = bounds.width
            self.height = bounds.height
            self.nativeWidth = nativeBounds.width
            self.nativeHeight = nativeBounds.height
        }
        
        
        self.scale = self.nativeWidth / self.width
        self.modelName = DeviceModel.getName()
        self.modelID = DeviceModel.getIdentifier()
        
        self.ppi = self.getPixelPerInch()
        
        DisplayUtil.SCALE = self.scale
        DisplayUtil.PPI = self.ppi
        
        self.displayWidth_mm = DisplayUtil.pixel2mm(self.width)
        self.displayHeight_mm = DisplayUtil.pixel2mm(self.height)
        self.displayWidth_inch = DisplayUtil.pixel2inch(self.width)
        self.displayHeight_inch = DisplayUtil.pixel2inch(self.height)
    }
    
    private func getPixelPerInch() -> CGFloat
    {
        let _height = self.nativeHeight
        if _height == 480
        {
            return 163.0
        }
        if self.modelName.range(of: "iPhone") != nil
        {
            if _height == 1920
            {
                return 401.0
            }
            if _height == 2436
            {
                return 458.0
            }
            return 326.0
        }
        
        
        if self.modelName.range(of: "iPad 2") != nil
        {
            return 132.0
        }
        if self.modelName.range(of: "iPad Mini") != nil
        {
            if _height == 1024
            {
                return 163.0
            }
            return 326.0
        }
        if self.modelName.range(of: "iPad Air") != nil
        {
            return 264.0
        }
        if self.modelName.range(of: "iPad Pro") != nil
        {
            if self.modelName.range(of: "10.5-inch") != nil
            {
                if _height == 2048
                {
                    return 242.0
                }
                return 264.0
            }
            return 264.0
        }
        if self.modelName.range(of: "iPad") != nil
        {
            return 264.0
        }
        return 326.0
    }
    
    private func getSystemModelVersion() -> String
    {
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
        return identifier
    }
}


