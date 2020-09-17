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
    
    
    
    var pts: [CGPoint]{
        [leftTop, rightTop, leftBottom, rightBottom]
    }
    
  
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
    

    mutating
    func sortPointClockwise(){
         // 按左上，右上，右下，左下排序
        var result = [CGPoint](repeating: CGPoint.zero, count: 4)
        var minDistance: CGFloat = -1
        for p in pts{
            let distance = p.x * p.x + p.y * p.y
            if minDistance == -1 || distance < minDistance{
                result[0] = p
                minDistance = distance
            }
        }
        var leftPts = pts.filter { (pp) -> Bool in
            pp != result[0]
        }
        if leftPts[1].pointSideLine(left: result[0], right: leftPts[0]) * leftPts[2].pointSideLine(left: result[0], right: leftPts[0]) < 0{
            result[2] = leftPts[0]
        }
        else if leftPts[0].pointSideLine(left: result[0], right: leftPts[1]) * leftPts[2].pointSideLine(left: result[0], right: leftPts[1]) < 0{
            result[2] = leftPts[1]
        }
        else if leftPts[0].pointSideLine(left: result[0], right: leftPts[2]) * leftPts[1].pointSideLine(left: result[0], right: leftPts[2]) < 0{
            result[2] = leftPts[2]
        }
        leftPts = pts.filter { (pt) -> Bool in
            pt != result[0] && pt != result[2]
        }
        if leftPts[0].pointSideLine(left: result[0], right: result[2]) > 0{
            result[1] = leftPts[0]
            result[3] = leftPts[1]
        }
        else{
            result[1] = leftPts[1]
            result[3] = leftPts[0]
        }
        
        leftTop = result[0]
        rightTop = result[1]
        
        rightBottom = result[2]
        leftBottom = result[3]
    }
  
}






extension CGPoint{
    
    func pointSideLine(left lhs: CGPoint, right rhs: CGPoint) -> CGFloat{
        
        
        return (x - lhs.x) * (rhs.y - lhs.y) - (y - lhs.y) * (rhs.x - lhs.x)
        
    }
    
    
    
    
    
}
