//
//  Geom.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/13.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class Geom
{
    
    // 3つの点(三角形)から外心点(外接円の中心)を求める
    static func circumcircle(a:CGPoint, b:CGPoint, c:CGPoint) -> CGPoint
    {
        let x1:CGFloat = (a.y-c.y)*(a.y*a.y-b.y*b.y+a.x*a.x-b.x*b.x)
        let x2:CGFloat = (a.y-b.y)*(a.y*a.y-c.y*c.y+a.x*a.x-c.x*c.x)
        let x3:CGFloat = 2*(a.y-c.y)*(a.x-b.x)-2*(a.y-b.y)*(a.x-c.x)
        let y1:CGFloat = (a.x-c.x)*(a.x*a.x-b.x*b.x+a.y*a.y-b.y*b.y)
        let y2:CGFloat = (a.x-b.x)*(a.x*a.x-c.x*c.x+a.y*a.y-c.y*c.y)
        let y3:CGFloat = 2*(a.x-c.x)*(a.y-b.y)-2*(a.x-b.x)*(a.y-c.y)
        let px:CGFloat = (x1-x2)/x3
        let py:CGFloat = (y1-y2)/y3
        return CGPoint(x:px, y:py)
    }
    
    // 2点間の距離を調べる
    static func length(a:CGPoint, b:CGPoint) -> CGFloat
    {
        let x:CGFloat = a.x - b.x
        let y:CGFloat = a.y - b.y
        return sqrt(x * x + y * y)
    }
    
    // 2点の角度を調べる
    static func angle(a:CGPoint, b:CGPoint) -> CGFloat
    {
        let x:CGFloat = a.x - b.x
        let y:CGFloat = a.y - b.y
        return atan2(y, x)
    }
    
    // 点が線B→Aの右にあるか左にあるか（1=右、-1=左、0=線上）
    static func lineSide(pt:CGPoint, a:CGPoint, b:CGPoint) -> Int
    {
        let n:CGFloat = pt.x * (a.y - b.y) + a.x * (b.y - pt.y) + b.x * (pt.y - a.y)
        if n > 0
        {
            return 1
        }
        if n < 0
        {
            return -1
        }
        return 0
    }
    
    // 線分の範囲内にあるか判定
    static func line_overlaps(pt:CGPoint, a:CGPoint, b:CGPoint) -> Bool
    {
        if (((a.x >= pt.x && b.x <= pt.x) || (b.x >= pt.x && a.x <= pt.x)) && ((a.y >= pt.y && b.y <= pt.y) || (b.y >= pt.y && a.y <= pt.y)))
        {
            return true
        }
        return false
    }
    
    // 線ABと線CDの角度を調べる
    static func lineAngle(a:CGPoint, b:CGPoint, c:CGPoint, d:CGPoint) -> CGFloat
    {
        let abX:CGFloat = b.x - a.x
        let abY:CGFloat = b.y - a.y
        let cdX:CGFloat = d.x - c.x
        let cdY:CGFloat = d.y - c.y
        let r1:CGFloat = abX * cdX + abY * cdY
        let r2:CGFloat = abX * cdY - abY * cdX
        return atan2(r2, r1)
    }
    
    // 線分ABと線分CDが交差するか調べる
    static func intersection(a:CGPoint, b:CGPoint, c:CGPoint, d:CGPoint) -> Bool
    {
        if (((a.x-b.x)*(c.y-a.y)+(a.y-b.y)*(a.x-c.x)) * ((a.x-b.x)*(d.y-a.y)+(a.y-b.y)*(a.x-d.x)) < 0)
        {
            return (((c.x-d.x)*(a.y-c.y)+(c.y-d.y) * (c.x-a.x))*((c.x-d.x)*(b.y-c.y)+(c.y-d.y)*(c.x-b.x)) < 0)
        }
        return false
    }
    
    // 直線ABと直線CDの交点を調べる
    static func cross(a:CGPoint, b:CGPoint, c:CGPoint, d:CGPoint) -> CGPoint
    {
        var t1:CGFloat = a.x-b.x
        var t2:CGFloat = c.x-d.x
        if t1 == 0 { t1 = 0.0000001 }
        if t2 == 0 { t2 = 0.0000001 }
        let ta:CGFloat = (a.y-b.y) / t1
        let tb:CGFloat = (a.x*b.y - a.y*b.x) / t1
        let tc:CGFloat = (c.y-d.y) / t2
        let td:CGFloat = (c.x*d.y - c.y*d.x) / t2
        let px:CGFloat = (td-tb) / (ta-tc)
        let py:CGFloat = ta * px + tb
        return CGPoint(x:px, y:py)
    }
    
    //直線ABが直線CDに衝突したときの反射角度
    static func refrect(a:CGPoint, b:CGPoint, c:CGPoint, d:CGPoint) -> CGFloat
    {
        let aX:CGFloat = b.x-a.x
        let aY:CGFloat = b.y-a.y
        let bX:CGFloat = d.x-c.x
        let bY:CGFloat = d.y-c.y
        return atan2(aY, aX) + CGFloat(PI) + atan2(aX*bY-aY*bX, aX*bX+aY*bY) * 2
    }
    
    //点ptを線分ABに対して垂直に移動した時に交差する点を調べる
    static func perpPoint(pt:CGPoint, a:CGPoint, b:CGPoint, outside:Bool=false) -> CGPoint?
    {
        var dest:CGPoint = CGPoint()
        if(a.x == b.x)
        {
            dest.x = a.x;
            dest.y = pt.y;
        }
        else if(a.y == b.y)
        {
            dest.x = pt.x
            dest.y = a.y
        }
        else
        {
            let m1:CGFloat = (b.y - a.y) / (b.x - a.x)
            let b1:CGFloat = a.y - (m1 * a.x);
            let m2:CGFloat = -1.0 / m1
            let b2:CGFloat = pt.y - (m2 * pt.x)
            dest.x = (b2 - b1) / (m1 - m2)
            dest.y = (b2 * m1 - b1 * m2) / (m1 - m2)
        }
        
        if (outside)
        {
            return dest
        }
        // 線分の範囲内にあるか判定
        if ((a.x >= dest.x && b.x <= dest.x && a.y >= dest.y && b.y <= dest.y) || (b.x >= dest.x && a.x <= dest.x && b.y >= dest.y && a.y <= dest.y))
        {
            return dest
        }
        return nil
    }
    
    
    // 3次ベジェ曲線の座標を取得する (a=anchorA, b=controlA, c=controlB, d=anchorB, t=[0.0 <= 1.0])
    static func bezierCurve(a:CGPoint, b:CGPoint, c:CGPoint, d:CGPoint, t:CGFloat) -> CGPoint
    {
        let s:CGFloat = 1-t
        let nx:CGFloat = s*s*s*a.x + 3*s*s*t*b.x + 3*s*t*t*c.x + t*t*t*d.x
        let ny:CGFloat = s*s*s*a.y + 3*s*s*t*b.y + 3*s*t*t*c.y + t*t*t*d.y
        return CGPoint(x:nx, y:ny)
    }
    
    // 3次ベジェ曲線の座標を取得する (a=anchorA, b=controlA, c=controlB, d=anchorB, t=[0.0 <= 1.0])
    static func bezierCurve(a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat, t:CGFloat) -> CGFloat
    {
        let s:CGFloat = 1-t
        return s*s*s*a + 3*s*s*t*b + 3*s*t*t*c + t*t*t*d
    }
    
    
    // CatmullRom補間（スプライン曲線）の座標を取得する (a → b → c → d, t=[0.0 <= 1.0])
    static func catmullRom(a:CGPoint, b:CGPoint, c:CGPoint, d:CGPoint, t:CGFloat) -> CGPoint
    {
        let px:CGFloat = _catmullRom(a:a.x, b:b.x, c:c.x, d:d.x, t:t)
        let py:CGFloat = _catmullRom(a:a.y, b:b.y, c:c.y, d:d.y, t:t)
        return CGPoint(x:px, y:py)
    }
    
    // CatmullRom補間（スプライン曲線）の座標を取得する (a → b → c → d, t=[0.0 <= 1.0])
    static func catmullRom(a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat, t:CGFloat) -> CGFloat
    {
        return _catmullRom(a:a, b:b, c:c, d:d, t:t)
    }
    
    private static func _catmullRom(a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat, t:CGFloat) -> CGFloat
    {
        let v0:CGFloat = (c - a) * 0.5
        let v1:CGFloat = (d - b) * 0.5
        let t2:CGFloat = t * t
        let t3:CGFloat = t2 * t
        return (2*b-2*c+v0+v1) * t3+(-3*b+3*c-2*v0-v1) * t2+v0*t+b
    }
    
}
