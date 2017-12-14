//
//  AppConfig.swift
//  TABO-TOUCH
//
//  Created by Michiyasu Wada on 2017/09/05.
//  Copyright © 2017年 Michiyasu Wada. All rights reserved.
//

import UIKit

class AppConfig
{
    static let FPS:Double = 30.0
    static let SPEED:Float = 180.0
    static let MIN_NEAR_LENGTH:Float = 30.0 //タッチイベントを受け付けるTABOからの距離
    static let SIDE_SPACE:CGFloat = 30.0 //TABOの落下防止のため端に行くと止める
    static let DECELERATE_LENGTH:Float = 300 //目的地付近で減速しはじめる距離
    static let BG_COLOR:UIColor = UIColor.black
    static let DISPLAY_DRIVE_INFO:Bool = true
    static let MULTI_CONNECTION:Bool = false
    
    static let POINTER_IMAGE:String = "pointer.png"
    static let DIRECTION_IMAGE:String = "direction.png"
}
