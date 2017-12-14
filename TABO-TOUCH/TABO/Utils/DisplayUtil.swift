//
//  DisplayUnit.swift
//  tabo1
//
//  Created by Michiyasu Wada on 2015/12/16.
//  Copyright © 2015年 Michiyasu Wada. All rights reserved.
//

import UIKit

class DisplayUtil
{
    static var PPI:CGFloat = 264
    static var SCALE:CGFloat = 1
    static let MMPI:CGFloat = 25.4 // 1-inch == 25.4mm
    
    static func pixel2inch(_ pixel:CGFloat) -> CGFloat { return pixel * SCALE / PPI }
    static func pixel2mm(_ pixel:CGFloat) -> CGFloat   { return pixel * SCALE / PPI * MMPI }
    static func inch2pixel(_ inch:CGFloat) -> CGFloat  { return inch * PPI / SCALE }
    static func inch2mm(_ inch:CGFloat) -> CGFloat     { return inch * MMPI }
    static func mm2pixel(_ mm:CGFloat) -> CGFloat      { return mm / MMPI * PPI / SCALE }
    static func mm2inch(_ mm:CGFloat) -> CGFloat       { return mm / MMPI }
    
    static func pixel2inch(_ pixel:Float) -> Float { return pixel * fSCALE / fPPI }
    static func pixel2mm(_ pixel:Float) -> Float   { return pixel * fSCALE / fPPI * fMMPI }
    static func inch2pixel(_ inch:Float) -> Float  { return inch * fPPI / fSCALE }
    static func inch2mm(_ inch:Float) -> Float     { return inch * fMMPI }
    static func mm2pixel(_ mm:Float) -> Float      { return mm * fPPI / fMMPI / fSCALE }
    static func mm2inch(_ mm:Float) -> Float       { return mm / fMMPI }
    
    private static var fPPI:Float
    {
        return Float(PPI)
    }
    private static var fSCALE:Float
    {
        return Float(SCALE)
    }
    private static var fMMPI:Float
    {
        return Float(MMPI)
    }
    
}
