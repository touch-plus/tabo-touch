//
//  MainScene.swift
//  TABO-TOUCH
//
//  Created by Michiyasu Wada on 2017/09/05.
//  Copyright © 2017年 Michiyasu Wada. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class TaboAppDisplay
{
    var deviceInfo:DeviceInfo!
    
    let scene:SCNScene = SCNScene()
    let screen:SCNNode = SCNNode()
    let camera:SCNCamera = SCNCamera()
    let cameraNode:SCNNode = SCNNode()
    let lightNode:SCNNode = SCNNode()
    let ambientLightNode:SCNNode = SCNNode()
    var scnView:SCNView!
    var children:[SCNNode] = [SCNNode]()
    var offsetX:CGFloat = 0
    var offsetY:CGFloat = 0
    
    init(view:SCNView)
    {
        scnView = view
        scnView.scene = scene
        scnView.showsStatistics = false
        scnView.allowsCameraControl = false
        scnView.backgroundColor = AppConfig.BG_COLOR
        scnView.antialiasingMode = .multisampling2X
        
        self.deviceInfo = DeviceInfo.info
        self.offsetX = deviceInfo.width / 2
        self.offsetY = deviceInfo.height / 2
        
        camera.zNear = 1
        camera.zFar = 10000
        camera.automaticallyAdjustsZRange = true
        
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.castsShadow = true
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let light:SCNLight = SCNLight()
        light.type = SCNLight.LightType.omni
        light.spotInnerAngle = 0
        light.spotOuterAngle = 160
        light.zFar = 10000
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 0, z: 20)
        
        scene.rootNode.addChildNode(lightNode)
        
        let aspect:Float = Float(DeviceInfo.info.width / DeviceInfo.info.height)
        let h:Float = Float(DeviceInfo.info.width) / aspect * 0.5
        let r:Float = (60 / 180 * PI) * 0.5
        self.screen.position.z = (cameraNode.position.z - h / tan(r))
        addChild(node: self.screen)
        
        atachLandMark()
        
    }
    deinit {}
    
    public func info()
    {
        print("DeviceInfo.info")
        print("  name             = \(deviceInfo.name)")
        print("  modelName        = \(deviceInfo.modelName)")
        print("  modelID          = \(deviceInfo.modelID)")
        print("  width            = \(deviceInfo.width)")
        print("  height           = \(deviceInfo.height)")
        print("  nativeWidth      = \(deviceInfo.nativeWidth)")
        print("  nativeHeight     = \(deviceInfo.nativeHeight)")
        print("  ppi              = \(deviceInfo.ppi)")
        print("  scale            = \(deviceInfo.scale)")
        print("  displayWidth_mm  = \(deviceInfo.displayWidth_mm)")
        print("  displayHeight_mm = \(deviceInfo.displayHeight_mm)")
    }
    
    public func screenZ () -> CGFloat
    {
        return CGFloat((15.0 - camera.zNear) / (camera.zFar - camera.zNear))
    }
    
    public func clear()
    {
        for child:SCNNode in children
        {
            child.removeFromParentNode()
        }
        children.removeAll()
    }
    
    public func addChild(node:SCNNode)
    {
        children.append(node)
        scene.rootNode.addChildNode(node)
    }
    
    private func atachLandMark()
    {
        let vec1:SCNVector3 = SCNVector3(x:-0.01, y: 0.01, z:0)
        let vec2:SCNVector3 = SCNVector3(x: 0.01, y: 0.01, z:0)
        let vec3:SCNVector3 = SCNVector3(x: 0.01, y:-0.01, z:0)
        let vec4:SCNVector3 = SCNVector3(x:-0.01, y:-0.01, z:0)
        
        let positions:[SCNVector3] = [vec1, vec2, vec3, vec4]
        let indices:[CInt] = [0,2,1, 0,3,2]
        let indexData:NSData = NSData(bytes: indices, length: MemoryLayout<CInt>.size * indices.count)
        
        let geomSource:SCNGeometrySource = SCNGeometrySource(vertices: positions)
        let geomElement:SCNGeometryElement = SCNGeometryElement(data: indexData as Data, primitiveType: SCNGeometryPrimitiveType.triangles, primitiveCount: 2, bytesPerIndex: MemoryLayout<CInt>.size)
        let geom:SCNGeometry = SCNGeometry(sources: [geomSource], elements: [geomElement])
        
        let color:UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        let mat:SCNMaterial = geom.firstMaterial!
        mat.diffuse.contents = color
        let node:SCNNode = SCNNode(geometry: geom)
        node.position = convertScreenToSpace(vp: CGPoint.zero, fixed:true)
        self.scene.rootNode.addChildNode(node)
    }
    
    public func convertScreenToSpace(vp:CGPoint, fixed:Bool=false) -> SCNVector3
    {
        if fixed
        {
            let scale:CGFloat = 0.00493092248862691
            return SCNVector3(
                x: Float((vp.x - offsetX) * scale),
                y:-Float((vp.y - offsetY) * scale),
                z: 9.1)
        }
        else
        {
            let vpWithDepth:SCNVector3 = SCNVector3(
                x:Float(vp.x),
                y:Float(vp.y),
                z:0.5)
            let scenePoint:SCNVector3 = self.scnView.unprojectPoint(vpWithDepth)
            return scenePoint
        }
    }
    
    
}
