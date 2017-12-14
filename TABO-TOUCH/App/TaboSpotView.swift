//
//  SpotView.swift
//  TABO-PONG
//
//  Created by Michiyasu Wada on 2016/02/18.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import SceneKit

class TaboSpotView:SCNNode
{
    
    var onNode:SCNNode!
    var offNode:SCNNode!
    
    private var _scale:CGFloat = 1
    private var _size:CGSize!
    
    
    
    func setup()
    {
        _scale = 0.5
        let _onImage:UIImage = UIImage(named: "connect_spot_on")!
        let _offImage:UIImage = UIImage(named: "connect_spot_off")!
        _size = _onImage.size
        
        let onGeom:SCNGeometry = SCNPlane(width: _size.width * _scale, height: _size.height * _scale)
        onGeom.firstMaterial?.diffuse.contents = _onImage
        onNode = SCNNode(geometry: onGeom)
        onNode.opacity = 0
        onNode.position.z = 1
        addChildNode(onNode)
        
        let offGeom:SCNGeometry = SCNPlane(width: _size.width * _scale, height: _size.height * _scale)
        offGeom.firstMaterial?.diffuse.contents = _offImage
        offNode = SCNNode(geometry: offGeom)
        offNode.opacity = 0
        addChildNode(offNode)
    }
    
    func show()
    {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.45
        SCNTransaction.animationTimingFunction = easing(Ease.EaseOutCubic)
        SCNTransaction.completionBlock = {
            
        }
        offNode.opacity = 1
        SCNTransaction.commit()
    }
    
    func on()
    {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.45
        SCNTransaction.animationTimingFunction = easing(Ease.EaseOutCubic)
        SCNTransaction.completionBlock = {
            
        }
        onNode.opacity = 1
        SCNTransaction.commit()
    }
    
    func off()
    {
        
    }
    
    func hide()
    {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.45
        SCNTransaction.animationTimingFunction = easing(Ease.Linear)
        SCNTransaction.completionBlock = {
            
        }
        onNode.opacity = 0
        offNode.opacity = 0
        SCNTransaction.commit()
    }
    
    
}
