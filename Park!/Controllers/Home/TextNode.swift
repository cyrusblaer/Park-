//
//  TextNode.swift
//  ARKeyboard
//
//  Created by Mark Zhong on 7/20/17.
//  Copyright © 2017 Mark Zhong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class TextNode: SCNNode {
    
    var scnText = SCNText() {
        didSet {
            self.geometry = scnText
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(distance:Float, scntext:SCNText, sceneView:ARSCNView, scale:CGFloat, offset: Float){
        super.init()

    
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let mat = pointOfView.transform
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        let offsetPosition = SCNVector3.init(pointOfView.position.x, pointOfView.position.y  + offset, pointOfView.position.z)
        let currentPosition = offsetPosition + (dir * distance)
        
        
        self.geometry = scntext
        self.position = currentPosition
        self.simdRotation = pointOfView.simdRotation
        self.setPivot()
        self.scale = SCNVector3(scale, scale, scale)
        
    }
    
    
}
