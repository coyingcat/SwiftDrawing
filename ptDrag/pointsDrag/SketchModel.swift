//
//  SketchModel.swift
//  pointsDrag
//
//  Created by Jz D on 2020/9/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit






struct SketchModel{
    var leftTop: CGPoint
    var rightTop: CGPoint
    var leftBottom: CGPoint
    var rightBottom: CGPoint
    
    var restPoints = [CGPoint]()
    
    
  
    var gimpTransformPolygonIsConvex: Bool{
        
        let x1 = leftTop.x, y1 = leftTop.y
        let x2 = rightTop.x, y2 = rightTop.y
        let x3 = leftBottom.x, y3 = leftBottom.y
        let x4 = rightBottom.x, y4 = rightBottom.y
     
        let z1 = ((x2 - x1) * (y4 - y1) - (x4 - x1) * (y2 - y1))
        let z2 = ((x4 - x1) * (y3 - y1) - (x3 - x1) * (y4 - y1))
        let z3 = ((x4 - x2) * (y3 - y2) - (x3 - x2) * (y4 - y2))
        let z4 = ((x3 - x2) * (y1 - y2) - (x1 - x2) * (y3 - y2))
     
        return (z1 * z2 > 0) && (z3 * z4 > 0)
    }
    
    
    
    init() {
        leftTop = CGPoint(x: 10, y: 10)
        
        rightTop = CGPoint(x: 100, y: 10)
        
        
        leftBottom = CGPoint(x: 10, y: 100)
        
        rightBottom = CGPoint(x: 100, y: 100)
    }
    
    
  
}
