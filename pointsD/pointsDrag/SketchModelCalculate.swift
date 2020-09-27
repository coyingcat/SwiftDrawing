//
//  SketchModelCalculate.swift
//  pointsDrag
//
//  Created by Jz D on 2020/9/25.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


typealias ReturnRightCenter = (rhsTop: CGPoint, rhsBottom: CGPoint)

typealias ReturnBottomCenter = (lhsBottom: CGPoint, rhsBottom: CGPoint)


typealias ReturnLeftCenter = (lhsTop: CGPoint, lhsBottom: CGPoint)

typealias ReturnTopCenter = (lhsTop: CGPoint, rhsTop: CGPoint)


extension CGPoint{
    

    
    
    
    func calculateTopCenter(lhsTopP lhsTop: CGPoint, rhsTopP rhsTop: CGPoint, rhsBottomP rhsBottom: CGPoint, lhsBottomP lhsBottom: CGPoint) -> ReturnTopCenter{
        
        var result: ReturnTopCenter = (CGPoint.zero, CGPoint.zero)
        
        let topDistance = rhsTop.x - lhsTop.x
        var lhsV = true, rhsV = true
        
        
        
        let lhsDistance = lhsTop.x - lhsBottom.x
        if abs(lhsDistance) < SketchConst.std.limite{
            lhsV = false
        }
        let rhsDistance = rhsTop.x - rhsBottom.x
        if abs(rhsDistance) < SketchConst.std.limite{
            rhsV = false
        }
        
        
        
        let k = (rhsTop.y - lhsTop.y)/topDistance
        
        //  (a-y)/w-(c-y)/k=b-d
        
        // 求解 y
        
        //  -(((d-b)*k-c)*w+a*k)/(w-k)
        
        //  (((b - d)*k + c)*w - a*k)/(w - k)
        
        //  (((d-b)*k-c)*w+a*k)/(k - w)
        
        ////
        
        ///
        
        //  (a-y)/w=b-x
        
        //  求解 x
        
        //  x = (y+b*w-a)/w
        
        
        if lhsV{
            let w = (lhsTop.y - lhsBottom.y)/lhsDistance
            let retY = (((lhsBottom.x - x) * k + y) * w - lhsBottom.y * k)/(w - k)
            result.lhsTop = CGPoint(x: (retY + lhsBottom.x * w - lhsBottom.y)/w, y: retY)
        }
        else{
            let resultY = (lhsBottom.x - x) * k + y
            result.lhsTop = CGPoint(x: lhsTop.x, y: resultY)
        }
        
        if rhsV{
            let rhs = (rhsTop.y - rhsBottom.y)/rhsDistance
            let rhsY = (k * rhsBottom.y + ((x - rhsBottom.x)*k - y) * rhs)/(k - rhs)
            result.rhsTop = CGPoint(x: (rhsY + rhsBottom.x * rhs - rhsBottom.y)/rhs, y: rhsY)
        }
        else{
            let rhsY = y - (x - rhsBottom.x)*k
            result.rhsTop = CGPoint(x: rhsTop.x, y: rhsY)
        }
        
        return result
    }
    
    
    
    
        
    
    func calculateRightCenter(lhsTopP lhsTop: CGPoint, rhsTopP rhsTop: CGPoint, rhsBottomP rhsBottom: CGPoint, lhsBottomP lhsBottom: CGPoint) -> ReturnRightCenter{
        
        var result: ReturnRightCenter = (CGPoint.zero, CGPoint.zero)
        
        let rhsDistance = rhsTop.y - rhsBottom.y
        var topH = true, bottomH = true


        let topDistance = rhsTop.y - lhsTop.y
        if abs(topDistance) < SketchConst.std.limite{
            topH = false
        }
        let bottomDistance = rhsBottom.y - lhsBottom.y
        if abs(bottomDistance) < SketchConst.std.limite{
            bottomH = false
        }

        let k = (rhsTop.x - rhsBottom.x)/rhsDistance

        if topH{
            let ths = (rhsTop.x - lhsTop.x)/topDistance
            let resX = (((lhsTop.y - y) * ths - lhsTop.x)*k + x * ths)/(ths - k)
            result.rhsTop = CGPoint(x: resX, y: (resX + y * k - x)/k)
        }
        else{
            result.rhsTop = CGPoint(x:  (lhsTop.y - y) * k + x, y: rhsTop.y)
        }

        if bottomH{
            let bhs = (rhsBottom.x - lhsBottom.x)/bottomDistance
            let resultX = (((rhsBottom.y - y) * bhs - rhsBottom.x)*k + x * bhs)/(bhs - k)
            result.rhsBottom = CGPoint(x: resultX, y: (resultX + y * k - x)/k)
        }
        else{
            result.rhsBottom = CGPoint(x: (rhsBottom.y - y) * k + x, y: rhsBottom.y)
        }
        return result
    }
    
    
    
    
    func calculateBottomCenter(lhsTopP lhsTop: CGPoint, rhsTopP rhsTop: CGPoint, rhsBottomP rhsBottom: CGPoint, lhsBottomP lhsBottom: CGPoint) -> ReturnBottomCenter{
        
        var result: ReturnBottomCenter = (CGPoint.zero, CGPoint.zero)
        
        let bottomDistance = rhsBottom.x - lhsBottom.x
        var lhsV = true, rhsV = true
        
        let lhsDistance = lhsTop.x - lhsBottom.x
        if abs(lhsDistance) < SketchConst.std.limite{
            lhsV = false
        }
        let rhsDistance = rhsTop.x - rhsBottom.x
        if abs(rhsDistance) < SketchConst.std.limite{
            rhsV = false
        }
        
        let k = (rhsBottom.y - lhsBottom.y)/bottomDistance
        
        if lhsV{
            let w = (lhsTop.y - lhsBottom.y)/lhsDistance
            let retY = (((lhsBottom.x - x) * k + y) * w - lhsBottom.y * k)/(w - k)
            result.lhsBottom = CGPoint(x: (retY + x * k - y)/k, y: retY)
        }
        else{
            let resultY = (lhsBottom.x - x) * k + y
            result.lhsBottom = CGPoint(x: lhsBottom.x, y: resultY)
        }
        
            

         //  -(((d-b)*k-c)*w+a*k)/(w-k)
         
         //  (((b - d)*k + c)*w - a*k)/(w - k)
         
         //  (((d-b)*k-c)*w+a*k)/(k - w)


              //  x = (y+b*w-a)/w
        if rhsV{
            let rhs = (rhsTop.y - rhsBottom.y)/rhsDistance
            let rhsY = (k * rhsBottom.y + ((x - rhsBottom.x)*k - y) * rhs)/(k - rhs)
            result.rhsBottom = CGPoint(x: (rhsY + rhsBottom.x * rhs - rhsBottom.y)/rhs, y: rhsY)
        }
        else{
            let rhsY = y - (x - rhsBottom.x)*k
            result.rhsBottom = CGPoint(x: rhsBottom.x, y: rhsY)
        }
        return result
    }
    
    
    
    
    func calculateLeftCenter(lhsTopP lhsTop: CGPoint, rhsTopP rhsTop: CGPoint,  rhsBottomP rhsBottom: CGPoint, lhsBottomP lhsBottom: CGPoint) -> ReturnLeftCenter{
        
        var result: ReturnLeftCenter = (CGPoint.zero, CGPoint.zero)
        
        let lhsDistance = lhsTop.y - lhsBottom.y
        var topH = true, bottomH = true
        
        
        let topDistance = rhsTop.y - lhsTop.y
        if abs(topDistance) < SketchConst.std.limite{
            topH = false
        }
        let bottomDistance = rhsBottom.y - lhsBottom.y
        if abs(bottomDistance) < SketchConst.std.limite{
            bottomH = false
        }

        let k = (lhsTop.x - lhsBottom.x)/lhsDistance
                    
        if topH{
            let ths = (rhsTop.x - lhsTop.x)/topDistance
            let responseX = (((rhsTop.y - y) * ths - rhsTop.x)*k + x * ths)/(ths - k)
            result.lhsTop = CGPoint(x: responseX, y: (responseX + y * k - x)/k)
       
        }
        else{
            result.lhsTop = CGPoint(x: (rhsTop.y - y) * k + x, y: lhsTop.y)
        }
        
        if bottomH{
            let bhs = (rhsBottom.x - lhsBottom.x)/bottomDistance
            let retX = (((rhsBottom.y - y) * bhs - rhsBottom.x)*k + x * bhs)/(bhs - k)
            result.lhsBottom = CGPoint(x: retX, y: (retX + y * k - x)/k)
        }
        else{
            result.lhsBottom = CGPoint(x: (rhsBottom.y - y) * k + x, y: lhsBottom.y)
        }
        return result
    }
    
    
    
    
    
    
    
}
