//
//  SketchModel.swift
//  pointsDrag
//
//  Created by Jz D on 2020/9/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


// 沿着固定的轨道
struct StateKeep {
    var lhsTop: CGPoint?
    var rhsTop: CGPoint?
    
    var lhsBottom: CGPoint?
    var rhsBottom: CGPoint?
    
    var keeping = false
    
}



struct SketchConst{
    
    static let std = SketchConst()
    
    let limite: CGFloat = 6
    
    let radius: CGFloat = 30
    let distance: CGFloat
    
    init() {
        distance = radius * 4
    }
}


struct SketchModel{
    var leftTop: CGPoint
    var rightTop: CGPoint
    var leftBottom: CGPoint
    var rightBottom: CGPoint
    
    
    
    
    
    
    var currentState = StateKeep()
    
    var restCorners = [CGPoint]()
    var nearCorners = [CGPoint]()
    
    var doingParallel = false{
        didSet{
            if doingParallel{
                if currentState.keeping == false{
                    currentState.keeping = true
                    currentState.lhsTop = leftTop
                    currentState.rhsTop = rightTop
                    currentState.lhsBottom = leftBottom
                    currentState.rhsBottom = rightBottom
                }
            }
            else{
                currentState.keeping = false
                currentState.lhsTop = nil
                currentState.rhsTop = nil
                currentState.lhsBottom = nil
                currentState.rhsBottom = nil
            }
        }
    }
    
    
    var lnTopCenter: CGPoint{
        get{
            centerPoint(from: leftTop, to: rightTop)
        }
        set{
            doingParallel = true
            guard let rhsTop = currentState.rhsTop, let lhsTop = currentState.lhsTop,
                let rhsBottom = currentState.rhsBottom , let lhsBottom = currentState.lhsBottom else{
                    return
            }
            
            
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
                let y = (((lhsBottom.x - newValue.x) * k + newValue.y) * w - lhsBottom.y * k)/(w - k)
                leftTop.y = y
                leftTop.x = (y + lhsBottom.x * w - lhsBottom.y)/w
            }
            else{
                let y = (lhsBottom.x - newValue.x) * k + newValue.y
                leftTop.y = y
            }
            
            if rhsV{
                let rhs = (rhsTop.y - rhsBottom.y)/rhsDistance
                let rhsY = (k * rhsBottom.y + ((newValue.x - rhsBottom.x)*k - newValue.y) * rhs)/(k - rhs)
                rightTop.y = rhsY
                rightTop.x = (rhsY + rhsBottom.x * rhs - rhsBottom.y)/rhs
            }
            else{
                let rhsY = newValue.y - (newValue.x - rhsBottom.x)*k
                rightTop.y = rhsY
            }
            
            
        }
    }

  
    var lnLeftCenter: CGPoint{
        get{
            centerPoint(from: leftTop, to: leftBottom)
        }
        set{
            doingParallel = true
            guard let rhsTop = currentState.rhsTop, let lhsTop = currentState.lhsTop,
                let rhsBottom = currentState.rhsBottom , let lhsBottom = currentState.lhsBottom else{
                    return
            }
            
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
                let x = (((rhsTop.y - newValue.y) * ths - rhsTop.x)*k + newValue.x * ths)/(ths - k)
                leftTop.x = x
                leftTop.y = (x + newValue.y * k - newValue.x)/k
            }
            else{
                leftTop.x = (rhsTop.y - newValue.y) * k + newValue.x
            }
            
            if bottomH{
                let bhs = (rhsBottom.x - lhsBottom.x)/bottomDistance
                let x = (((rhsBottom.y - newValue.y) * bhs - rhsBottom.x)*k + newValue.x * bhs)/(bhs - k)
                leftBottom.x = x
                leftBottom.y = (x + newValue.y * k - newValue.x)/k
            }
            else{
                leftBottom.x = (rhsBottom.y - newValue.y) * k + newValue.x
            }
            
            
        }
    }

    
    
    var lnBottomCenter: CGPoint{
        get{
            centerPoint(from: leftBottom, to: rightBottom)
        }
        set{
            
            doingParallel = true
            
            guard let rhsTop = currentState.rhsTop, let lhsTop = currentState.lhsTop,
                let rhsBottom = currentState.rhsBottom , let lhsBottom = currentState.lhsBottom else{
                    return
            }
            
            let result = newValue.calculatelnBottomCenter(rhsTopP: rhsTop, lhsTopP: lhsTop, rhsBottomP: rhsBottom, lhsBottomP: lhsBottom)
            leftBottom = result.lhsBottom
            rightBottom = result.rhsBottom
            
        }
    }
    
    
    
    var lnRightCenter: CGPoint{
        get{
            centerPoint(from: rightTop, to: rightBottom)
        }
        set{
            doingParallel = true
            guard let rhsTop = currentState.rhsTop, let lhsTop = currentState.lhsTop,
                let rhsBottom = currentState.rhsBottom , let lhsBottom = currentState.lhsBottom else{
                    return
            }
            
            let gotIt = newValue.calculatelnRightCenter(rhsTopP: rhsTop, lhsTopP: lhsTop, rhsBottomP: rhsBottom, lhsBottomP: lhsBottom)
            rightTop = gotIt.rhsTop
            rightBottom = gotIt.rhsBottom
        }
    }


    
    
    private
    func centerPoint(from fromPoint: CGPoint, to toPoint: CGPoint) -> CGPoint{
        return CGPoint(x: (fromPoint.x + toPoint.x)/2, y: (fromPoint.y + toPoint.y)/2)
    }
    
    
    
    
    init() {
        leftTop = CGPoint(x: 10, y: 10)
        
        rightTop = CGPoint(x: 300, y: 10)
        
        
        leftBottom = CGPoint(x: 10, y: 300)
        
        rightBottom = CGPoint(x: 300, y: 300)
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

}
