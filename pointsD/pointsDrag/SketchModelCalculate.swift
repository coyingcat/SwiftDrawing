//
//  SketchModelCalculate.swift
//  pointsDrag
//
//  Created by Jz D on 2020/9/25.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit




extension CGPoint{
    
typealias ReturnRightCenter = (rhsTop: CGPoint, rhsBottom: CGPoint)
        
    
    func calculatelnRightCenter(rhsTopP rhsTop: CGPoint, lhsTopP lhsTop: CGPoint, rhsBottomP rhsBottom: CGPoint, lhsBottomP lhsBottom: CGPoint) -> ReturnRightCenter{
        
        var result: ReturnRightCenter = (CGPoint.zero, CGPoint.zero)
        
        let rhsDistance = rhsTop.y - rhsBottom.y
        var topH = true, bottomH = true


        let topDistance = rhsTop.y - lhsTop.y
        if abs(topDistance) < SketchConst.limite{
            topH = false
        }
        let bottomDistance = rhsBottom.y - lhsBottom.y
        if abs(bottomDistance) < SketchConst.limite{
            bottomH = false
        }

        let k = (rhsTop.x - rhsBottom.x)/rhsDistance

        if topH{
            let ths = (rhsTop.x - lhsTop.x)/topDistance
            let resX = (((lhsTop.y - y) * ths - lhsTop.x)*k + x * ths)/(ths - k)
            result.rhsTop = CGPoint(x: resX, y: (resX + y * k - resX)/k)
        }
        else{
            result.rhsTop = CGPoint(x:  (lhsTop.y - y) * k + x, y: y)
        }

        if bottomH{
            let bhs = (rhsBottom.x - lhsBottom.x)/bottomDistance
            let resultX = (((rhsBottom.y - y) * bhs - rhsBottom.x)*k + x * bhs)/(bhs - k)
            result.rhsBottom = CGPoint(x: resultX, y: (resultX + y * k - resultX)/k)
        }
        else{
            result.rhsBottom = CGPoint(x: (rhsBottom.y - y) * k + x, y: y)
        }
        return result
    }
}
