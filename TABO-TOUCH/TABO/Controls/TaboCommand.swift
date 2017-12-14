//
//  TaboCommand.swift
//  TaboDemo1
//
//  Created by Michiyasu Wada on 2016/01/04.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//
import UIKit

/// TABOコマンド生成クラス
public class TaboCommand
{
    /// TABO コア系コマンドラッパークラスインスタンス
    var core:TaboCommandCore!
    /// TABO 移動系コマンドラッパークラスインスタンス
    var move:TaboCommandMove!
    /// TABO LED系コマンドラッパークラスインスタンス
    var led:TaboCommandLED!
    
    private var _com:TABOCMD!
    
    /// TABOコマンド定義クラスのバージョン
    var version:String
    {
        get {
            return _com.version
        }
    }
    
    init(cmd:TABOCMD)
    {
        _com = cmd
        core = TaboCommandCore(cmd: cmd)
        move = TaboCommandMove(cmd: cmd)
        led = TaboCommandLED(cmd: cmd)
    }
    deinit {}
}

/// TABO コマンド定義クラス
public class TABOCMD
{
    var version:String = "2.0"
    var SCALE:Float = 1
    
    var SHUTDOWN:String = "X"
    var BATTERY:String = "GBI"
    var SLEEP:String = "CES"
    var VERSION:String = "GVI"
    var PING:String = "ping"
    
    var FORWARD:String = "MLI"
    var ROTATE:String = "tMTI"
    var FORWARD2:String = "MLL"
    var ROTATE2:String = "MTL"
    var DIRECT:String = "MDD"
    var DIRECT_LED:String = "BDL"
    var STOP:String = "BHL"
    
    var LED:String = "LAI"
}

/// TABO コマンド基底クラス
public class TABOCommandBase
{
    internal var cmd:TABOCMD!
    internal var maxv:Float = 0
    internal var minv:Float = 0
    internal var PI:Float = Float.pi
    internal var PI_2:Float = Float.pi/2
    
    internal init(cmd:TABOCMD)
    {
        self.cmd = cmd
        self.maxv = Float(cmd.SCALE * 400)
        self.minv = Float(cmd.SCALE * -400)
    }
    
    internal func range(_ i:Int) -> Int
    {
        if i > Int(maxv)
        {
            return Int(maxv)
        }
        if i < Int(minv)
        {
            return Int(minv)
        }
        return i
    }

    
    internal func range(_ i:Float) -> Float
    {
        if i > maxv
        {
            return maxv
        }
        if i < minv
        {
            return minv
        }
        return i
    }
    
    internal func range2(_ i:Float, _ min_value:Float, _ max_value:Float) -> Float
    {
        if i > max_value
        {
            return max_value
        }
        if i < min_value
        {
            return min_value
        }
        return i
    }
    
    internal func easeIn(_ t:Float) -> Float
    {
        return t * t * t
    }
    
    internal func easeOut(_ t:Float) -> Float
    {
        let i:Float = 1 - t
        return 1 - (i * i * i)
    }
    
    internal func easeInOut(_ t:Float) -> Float
    {
        if t < 0.5
        {
            return easeIn(t * 2) * 0.5
        }
        return easeOut(t * 2 - 1) * 0.5 + 0.5
    }
}

/// TABO コア系コマンドラッパークラス
public class TaboCommandCore:TABOCommandBase
{
    /**
     全ての実行中コマンドを停止するコマンド文字列取得<br />
     ・モーター制御：停止<br />
     ・LED制御：消灯
     
     - returns: コマンド文字列
     */
    func shutdown() -> String       { return "\(cmd.SHUTDOWN)" }
    /**
     バッテリー残量を要求する。<br />
     返信はバッテリー残量をパーセンテージであらわした数字3桁。<br />
     例： 100 [%] ⇒ gbi:100<br />
     例：  50 [%] ⇒ gbi:050<br />
     例：   5 [%] ⇒ gbi:005<br />
     例：   0 [%] ⇒ gbi:000
     
     - returns: コマンド文字列
     */
    func battery() -> String        { return "\(cmd.BATTERY)" }
    /**
     TABOのスリープコマンド文字列取得
     電源スイッチ押下と同じ効果。
     
     - returns: コマンド文字列
     */
    func sleep() -> String          { return "\(cmd.SLEEP)" }
    /**
     バージョン取得コマンド文字列取得
     
     - returns: コマンド文字列
     */
    func version() -> String        { return "\(cmd.VERSION)" }
    /**
     接続確認コマンド文字列取得
     
     - returns: コマンド文字列
     */
    func ping() -> String           { return "\(cmd.PING)" }
    func scale() -> Float           { return cmd.SCALE }
}

public class TaboCommandMove:TABOCommandBase
{
    
    /**
     直進コマンド文字列取得<br />
     正の値：前進、負の値：後進
     
     - parameter length: 進む長さ指定(mm)
     
     - returns: コマンド文字列
     */
    func forward(length:Float) -> String
    {
        if length == Float.infinity || length == Float.nan
        {
            return "\(cmd.FORWARD):0"
        }
        return "\(cmd.FORWARD):\(range(Int(length * cmd.SCALE)))"
    }
    /**
     Deprecated
     */
    func rotate(degree:Float) -> String
    {
        if degree == Float.infinity || degree == Float.nan
        {
            return "\(cmd.ROTATE):0"
        }
        return "\(cmd.ROTATE):\(Int(degree))"
    }
    /**
     距離指定直進コマンド文字列取得<br />
     移動する距離を指定し、直進移動を行うコマンド
     
     - parameter sec:    移動する時間指定
     - parameter length: 移動する距離(mm)指定
     
     - returns: コマンド文字列
     */
    func forward2(sec:Float, length:Float) -> String
    {
        if length == Float.infinity || length == Float.nan
        {
            return "\(cmd.FORWARD2):0,0"
        }
        if sec == Float.infinity || sec == Float.nan
        {
            return "\(cmd.FORWARD2):0,0"
        }
        if length == 0 || sec == 0
        {
            return "\(cmd.FORWARD2):0,0"
        }
        return "\(cmd.FORWARD2):\(Int(length * cmd.SCALE / sec)),\(range(Int(length * cmd.SCALE)))"
    }
    /**
     角度指定旋回コマンド文字列取得<br />
     回転する角度を指定し、回転を行う。
     
     - parameter sec:    回転する時間
     - parameter degree: 回転する角度
     
     - returns: コマンド文字列
     */
    func rotate2(sec:Float, degree:Float) -> String
    {
        if degree == Float.infinity || degree == Float.nan
        {
            return "\(cmd.ROTATE2):0,0"
        }
        if sec == Float.infinity || sec == Float.nan
        {
            return "\(cmd.ROTATE2):0,0"
        }
        if degree == 0 || sec == 0
        {
            return "\(cmd.ROTATE2):0,0"
        }
        return "\(cmd.ROTATE2):\(Int(degree/sec)),\(Int(degree))"
    }
    
    /**
     両車輪速度指定によるダイレクトドライブコマンド文字列取得
     
     - parameter left:  左車輪移動速度[mm/sec]
     - parameter right: 右車輪移動速度[mm/sec]
     
     - returns: コマンド文字列
     */
    func direct(left:Float, right:Float) -> String
    {
        if left == Float.infinity || left == Float.nan
        {
            return "\(cmd.DIRECT):0,0"
        }
        if right == Float.infinity || right == Float.nan
        {
            return "\(cmd.DIRECT):0,0"
        }
        return "\(cmd.DIRECT):\(range(Int(left * cmd.SCALE))),\(range(Int(right * cmd.SCALE)))"
    }
    
    func directLED(left:Float, right:Float, led:String) -> String
    {
        if left == Float.infinity || left == Float.nan
        {
            return "\(cmd.DIRECT_LED):0,0,\(led)"
        }
        if right == Float.infinity || right == Float.nan
        {
            return "\(cmd.DIRECT_LED):0,0,\(led)"
        }
        return "\(cmd.DIRECT_LED):\(range(Int(left * cmd.SCALE))),\(range(Int(right * cmd.SCALE))),\(led)"
    }
    
    func directLED(left:Float, right:Float, led:LED) -> String
    {
        let color:String = led.getColor()
        if left == Float.infinity || left == Float.nan
        {
            return "\(cmd.DIRECT_LED):0,0,\(color)"
        }
        if right == Float.infinity || right == Float.nan
        {
            return "\(cmd.DIRECT_LED):0,0,\(color)"
        }
        return "\(cmd.DIRECT_LED):\(range(Int(left * cmd.SCALE))),\(range(Int(right * cmd.SCALE))),\(color)"
    }
    
    func stop() -> String
    {
        return cmd.STOP
    }
    
    /**
     ダイレクトドライブコマンド文字列取得<br />
     指定の回転角度によって左車輪移動速度及び右車輪移動速度を計算し、コマンド文字列を返す
     
     - parameter speed:  速度[mm/sec]
     - parameter rotate: 回転角度
     
     - returns: コマンド文字列
     */
    public func drive(speed:Float, rotate:Float) -> String
    {
        var _rotate:Float = rotate / PI
        if _rotate > 1
        {
            _rotate = 1
        }
        else if _rotate < -1
        {
            _rotate = -1
        }
        
        var _speed:Float = speed * cmd.SCALE
        if _speed > maxv
        {
            _speed = maxv
        }
        else if _speed < minv
        {
            _speed = minv
        }
        var _left:Float = _speed
        var _right:Float = _speed
        if _rotate >= 0
        {
            _right -= abs(_rotate) * _speed * 2
        }
        else
        {
            _left -= abs(_rotate) * _speed * 2
        }
        return "\(cmd.DIRECT):\(Int(range(_left))),\(Int(range(_right)))"
    }
    
    /**
     tween回転用ダイレクトドライブコマンド文字列取得
     
     - parameter rotate: 回転角度
     - parameter t:      tweenのための0-1の係数（default:0）
     
     - returns: コマンド文字列
     */
    public func tweenRotate(_ rotate:Float, t:Float=0.0) -> String
    {
        let _t:Float = 1 - easeOut(range2(t, 0.0, 1.0))
        return direct(left: rotate * _t, right: -rotate * _t)
    }
    
    /**
     tween直進用ダイレクトドライブコマンド文字列取得
     
     - parameter len:    進む距離(mm)
     - parameter rotate: 回転角度
     - parameter t:      tweenのための0-1の係数（default:0）
     
     - returns: コマンド文字列
     */
    public func tweenDrive(len:Float, rotate:Float, t:Float=0.0) -> String
    {
        let _t:Float = 1 - easeOut(range2(t, 0.0, 1.0))
        return drive(speed:len * _t, rotate:rotate)
    }
    
}

/// TABO LED系コマンドラッパークラス
public class TaboCommandLED:TABOCommandBase
{
    
    
    /**
     LED制御 一括点灯コマンド文字列取得<br />
     
     
     - parameter level: 色レベルの指定(default:1)
     
     - returns: コマンド文字列
     */
    public func on(level:Float=1.0) -> String
    {
        let n:Int = color(val: level * 255)
        return "\(cmd.LED):\(n),\(n),\(n)"
    }
    
    /**
     LED制御 RGB指定による一括点灯コマンド文字列取得<br />
     
     - parameter red:   RGBのR指定(default:1)
     - parameter green: RGBのG指定(default:1)
     - parameter blue:  RGBのB指定(default:1)
     
     - returns: コマンド文字列
     */
    public func rgb(red:Float=1.0, green:Float=1.0, blue:Float=1.0) -> String
    {
        let r:Int = color(val: red * 255)
        let g:Int = color(val: green * 255)
        let b:Int = color(val: blue * 255)
        return "\(cmd.LED):\(r),\(g),\(b)"
    }
    
    /**
     LED制御 一括消灯コマンド文字列取得<br />
     
     - returns: コマンド文字列
     */
    public func off() -> String            { return "\(cmd.LED):0,0,0" }
    
    private func color(val:Float) -> Int
    {
        if val > 1
        {
            return 255
        }
        if val < 0
        {
            return 0
        }
        return Int(val * 255)
    }
}

