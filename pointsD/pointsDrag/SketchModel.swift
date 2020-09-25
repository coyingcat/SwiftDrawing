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
    
    
    
    var corners: [CGPoint]{
        [leftTop, rightTop,
         rightBottom, leftBottom]
    }
    
    
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
            let result = newValue.calculateTopCenter(lhsTopP: lhsTop, rhsTopP: rhsTop,  rhsBottomP: rhsBottom, lhsBottomP: lhsBottom)
            leftTop = result.lhsTop
            rightTop = result.rhsTop
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
            let result = newValue.calculateLeftCenter(lhsTopP: lhsTop, rhsTopP: rhsTop, rhsBottomP: rhsBottom, lhsBottomP: lhsBottom)
            leftTop = result.lhsTop
            leftBottom = result.lhsBottom
            
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
            
            let result = newValue.calculateBottomCenter(lhsTopP: lhsTop, rhsTopP: rhsTop, rhsBottomP: rhsBottom, lhsBottomP: lhsBottom)
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
            
            let gotIt = newValue.calculateRightCenter(lhsTopP: lhsTop, rhsTopP: rhsTop, rhsBottomP: rhsBottom, lhsBottomP: lhsBottom)
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
