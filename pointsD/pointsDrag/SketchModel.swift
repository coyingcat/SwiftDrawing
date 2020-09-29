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
    
    let radius: CGFloat = 20
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
    
    
    var oldCorners: [CGPoint]{
        guard let rhsTop = currentState.rhsTop, let lhsTop = currentState.lhsTop,
            let rhsBottom = currentState.rhsBottom , let lhsBottom = currentState.lhsBottom else{
                return []
        }
        return [lhsTop, rhsTop, rhsBottom, lhsBottom]
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
    
}




extension CGPoint{
    

    func gimpTransformPolygon(isConvex firstPt: CGPoint, two twicePt: CGPoint, three thirdPt: CGPoint) -> Bool{
        
        let x2 = firstPt.x, y2 = firstPt.y
        let x3 = twicePt.x, y3 = twicePt.y
        let x4 = thirdPt.x, y4 = thirdPt.y
     
        let z1 = ((x2 - x) * (y4 - y) - (x4 - x) * (y2 - y))
        let z2 = ((x4 - x) * (y3 - y) - (x3 - x) * (y4 - y))
        let z3 = ((x4 - x2) * (y3 - y2) - (x3 - x2) * (y4 - y2))
        let z4 = ((x3 - x2) * (y - y2) - (x - x2) * (y3 - y2))
     
        return (z1 * z2 > 0) && (z3 * z4 > 0)
    }
    
    
}
