//
//  TaboOperationDisplay.swift
//  TaboDemo
//
//  Created by Michiyasu Wada on 2016/01/12.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class TaboTouchDisplay
{
    private var _screen:SCNNode!
    private var _field:SCNNode!
    private var _tabo:TABO!
    private var _initialized:Bool = false
    private var _offsetX:Float = 0
    private var _offsetY:Float = 0
    private var _prevAngle:CGFloat = 0
    private var _moveAngle:CGFloat = 0
    private var _prevPos:CGPoint!
    private var _prevFrame:Int = 0
    
    init(screen:SCNNode)
    {
        _screen = screen
        _field = SCNNode()
        _screen.addChildNode(_field)
        _offsetX = -Float(DeviceInfo.info.width) / 2
        _offsetY = -Float(DeviceInfo.info.height) / 2
    }
    deinit{}
    
    public func setup(_ tabo:TABO)
    {
        _tabo = tabo
        _initialized = true
    }
    
    public func reset()
    {
        _tabo = nil
        _initialized = false
    }
    
    public func update(_ frames:Int)
    {
        if _initialized
        {
            updateDisplay(frames)
        }
    }
    
    public func addTouchMarker(_ pt:CGPoint)
    {
        if !AppConfig.DISPLAY_DRIVE_INFO
        {
            return
        }
        
        let radius:CGFloat = 100
        let geom:SCNPlane = SCNPlane(width: radius, height: radius)
        let mat:SCNMaterial = geom.firstMaterial!
        mat.diffuse.contents = UIImage(named: AppConfig.POINTER_IMAGE)
        mat.isDoubleSided = true
        let node:SCNNode = SCNNode(geometry: geom)
        _field.addChildNode(node)
        node.position.x = Float(pt.x) + _offsetX
        node.position.y = -(Float(pt.y) + _offsetY)
        node.position.z = 0
        node.castsShadow = false
        fadeOut(node)
    }
    
    private func updateDisplay(_ frames:Int)
    {
        let pos:CGPoint = CGPoint(x:_tabo.position.x + CGFloat(_offsetX), y:-(_tabo.position.y + CGFloat(_offsetY)))
        let angle:CGFloat = CGFloat(-_tabo.angle + PI/2)
        let leftWheel:CGFloat = CGFloat(_tabo.leftWheel)
        let rightWheel:CGFloat = CGFloat(_tabo.rightWheel)
        
        if frames % 4 != 0
        {
            _moveAngle += atan2(sin(angle - _prevAngle), cos(angle - _prevAngle))
            _prevAngle = angle
            return
        }
        
        if AppConfig.DISPLAY_DRIVE_INFO && _prevPos != nil && _prevPos.x != pos.x && _prevPos.y != pos.y
        {
            if pos.x != CGFloat(_offsetX) && pos.y != CGFloat(_offsetY)
            {
                let pie:SCNNode = drawRotatePie(position: pos, angle: angle)
                let circle:SCNNode = drawDirectionCircle(position: pos, angle: angle)
                let gauge:SCNNode = drawWheelGauge(position: pos, angle: angle, leftWheel:leftWheel, rightWheel:rightWheel)
                
                fadeOut(pie)
                fadeOut(circle)
                fadeOut(gauge)
            }
            _moveAngle = 0
        }
        
        _prevPos = pos
    }
    
    private func drawRotatePie(position pos:CGPoint, angle:CGFloat) -> SCNNode
    {
        let startAngle:CGFloat = angle + CGFloat.pi/2
        let endAngle:CGFloat = startAngle - _moveAngle
        let clockwise:Bool = _moveAngle < 0
        let outRadius:CGFloat = 80
        let inRadius:CGFloat = 24
        let path:UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x:cos(startAngle) * outRadius, y:sin(startAngle) * outRadius))
        path.addArc(withCenter: CGPoint.zero, radius: outRadius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        path.addLine(to: CGPoint(x:cos(endAngle) * inRadius, y:sin(endAngle) * inRadius))
        path.addArc(withCenter: CGPoint.zero, radius: inRadius, startAngle: endAngle, endAngle: startAngle, clockwise: !clockwise)
        
        let geom:SCNShape = SCNShape(path: path, extrusionDepth: 0)
        let mat:SCNMaterial = geom.firstMaterial!
        mat.diffuse.contents = UIColor(hue: 0.6, saturation: 1, brightness: 0.99, alpha: 1)
        mat.isDoubleSided = true
        let node:SCNNode = SCNNode(geometry: geom)
        _field.addChildNode(node)
        node.position.x = Float(pos.x)
        node.position.y = Float(pos.y)
        node.position.z = 0.1
        node.castsShadow = false
        return node
    }
    
    private func drawDirectionCircle(position pos:CGPoint, angle:CGFloat) -> SCNNode
    {
        let radius:CGFloat = 100
        let geom:SCNPlane = SCNPlane(width: radius * 2, height: radius * 2)
        let mat:SCNMaterial = geom.firstMaterial!
        mat.diffuse.contents = UIImage(named: AppConfig.DIRECTION_IMAGE)
        mat.isDoubleSided = true
        mat.blendMode = SCNBlendMode.add
        let node:SCNNode = SCNNode(geometry: geom)
        _field.addChildNode(node)
        node.position.x = Float(pos.x)
        node.position.y = Float(pos.y)
        node.position.z = 0.2
        node.rotation = SCNVector4.init(x: 0, y: 0, z: 1, w: Float(angle))
        node.castsShadow = false
        return node
    }
    
    private func drawWheelGauge(position pos:CGPoint, angle:CGFloat, leftWheel:CGFloat, rightWheel:CGFloat) -> SCNNode
    {
        let pi:CGFloat = CGFloat.pi
        let scale:CGFloat = CGFloat(0.5 / AppConfig.SPEED)
        let posi:UIColor = UIColor(red: 0.75, green: 0.95, blue: 0.25, alpha: 1)
        let nega:UIColor = UIColor(red: 0.25, green: 0.75, blue: 0.95, alpha: 1)
        let node:SCNNode = SCNNode()
        _field.addChildNode(node)
        
        let radius:CGFloat = 100
        let size:CGFloat = 10
        let leftPath:UIBezierPath = UIBezierPath()
        let leftAngle:CGFloat = pi / 2 * leftWheel * scale
        leftPath.addArc(withCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: leftAngle, clockwise: leftWheel >= 0)
        leftPath.addArc(withCenter: CGPoint.zero, radius: radius - size, startAngle: leftAngle, endAngle: 0, clockwise: leftWheel < 0)
        let leftGeom:SCNShape = SCNShape(path: leftPath, extrusionDepth: 0)
        let leftMat:SCNMaterial = leftGeom.firstMaterial!
        if leftWheel >= 0
        {
            leftMat.diffuse.contents = posi
        }
        else
        {
            leftMat.diffuse.contents = nega
        }
        leftMat.isDoubleSided = true
        leftMat.blendMode = SCNBlendMode.add
        let leftNode:SCNNode = SCNNode(geometry: leftGeom)
        node.addChildNode(leftNode)
        
        let rightPath:UIBezierPath = UIBezierPath()
        let rightAngle:CGFloat = pi - (pi / 2 * rightWheel * scale)
        rightPath.addArc(withCenter: CGPoint.zero, radius: radius, startAngle: pi, endAngle: rightAngle, clockwise: rightWheel < 0)
        rightPath.addArc(withCenter: CGPoint.zero, radius: radius - size, startAngle: rightAngle, endAngle: pi, clockwise: rightWheel >= 0)
        let rightGeom:SCNShape = SCNShape(path: rightPath, extrusionDepth: 0)
        let rightMat:SCNMaterial = rightGeom.firstMaterial!
        if rightWheel >= 0
        {
            rightMat.diffuse.contents = posi
        }
        else
        {
            rightMat.diffuse.contents = nega
        }
        rightMat.isDoubleSided = true
        rightMat.blendMode = SCNBlendMode.add
        let rightNode:SCNNode = SCNNode(geometry: rightGeom)
        node.addChildNode(rightNode)
        
        node.position.x = Float(pos.x)
        node.position.y = Float(pos.y)
        node.position.z = 0.3
        node.rotation = SCNVector4.init(x: 0, y: 0, z: 1, w: Float(angle))
        node.castsShadow = false
        
//        print("x=\(node.position.x), y=\(node.position.y), px=\(pos.x), py=\(pos.y)")
//        print("x=\(node.position.x), y=\(node.position.y), px=\(pos.x), py=\(pos.y), +x=\(_offsetX), +y=\(_offsetY)")
        
        _ = setTimeout(2, block: {()
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2.0
            SCNTransaction.completionBlock = {
                leftNode.removeFromParentNode()
                rightNode.removeFromParentNode()
            }
            leftMat.diffuse.contents = UIColor.black
            rightMat.diffuse.contents = UIColor.black
            SCNTransaction.commit()
        })
        
        return node
    }
    
    private func fadeOut(_ node:SCNNode)
    {
        _ = setTimeout(2, block: {()
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2.0
            SCNTransaction.completionBlock = {
                node.removeFromParentNode()
            }
            node.opacity = 0.0
            SCNTransaction.commit()
        })
    }
    
}
