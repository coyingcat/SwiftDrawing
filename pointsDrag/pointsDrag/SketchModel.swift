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




struct SketchModel{
    var leftTop: CGPoint
    var rightTop: CGPoint
    var leftBottom: CGPoint
    var rightBottom: CGPoint
    
    
    let limite: CGFloat = 6
    
    
    
    var currentState = StateKeep()
    
    
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
            if abs(lhsDistance) < limite{
                lhsV = false
            }
            let rhsDistance = rhsTop.x - rhsBottom.x
            if abs(rhsDistance) < limite{
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
                let y = (((lhsTop.x - newValue.x) * k + newValue.y) * w - lhsTop.y * k)/(w - k)
                leftTop.y = y
                leftTop.x = (y + newValue.x * w - newValue.y)/w
            }
            else{
                let y = (lhsTop.x - newValue.x) * k + newValue.y
                leftTop.y = y
            }
            
            if rhsV{
                let rhs = (rhsTop.y - rhsBottom.y)/rhsDistance
                let rhsY = (k * rhsTop.y + ((newValue.x - rhsTop.x)*k - newValue.y) * rhs)/(k - rhs)
                rightTop.y = rhsY
                rightTop.x = (rhsY + rhsTop.x * rhs - rhsTop.y)/rhs
            }
            else{
                let rhsY = newValue.y - (newValue.x - rhsTop.x)*k
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
            if abs(topDistance) < limite{
                topH = false
            }
            let bottomDistance = rhsBottom.y - lhsBottom.y
            if abs(bottomDistance) < limite{
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
            
            let bottomDistance = rhsBottom.x - lhsBottom.x
            var lhsV = true, rhsV = true
            
            let lhsDistance = lhsTop.x - lhsBottom.x
            if abs(lhsDistance) < limite{
                lhsV = false
            }
            let rhsDistance = rhsTop.x - rhsBottom.x
            if abs(rhsDistance) < limite{
                rhsV = false
            }
            
            let k = (rhsBottom.y - lhsBottom.y)/bottomDistance
            
            if lhsV{
                let w = (lhsTop.y - lhsBottom.y)/lhsDistance
                let y = (((lhsBottom.x - newValue.x) * k + newValue.y) * w - lhsBottom.y * k)/(w - k)
                leftBottom.y = y
                leftBottom.x = (y + newValue.x * k - newValue.y)/k
            }
            else{
                let y = (lhsBottom.x - newValue.x) * k + newValue.y
                leftBottom.y = y
            }
            
                
            
            
            
            
            if rhsV{
                let rhs = (rhsTop.y - rhsBottom.y)/rhsDistance
                let rhsY = (k * rhsBottom.y + ((newValue.x - rhsBottom.x)*k - newValue.y) * rhs)/(k - rhs)
                rightBottom.y = rhsY
                rightBottom.x = (rhsY + newValue.x * k - newValue.x)/k
            }
            else{
                let rhsY = newValue.y - (newValue.x - rhsBottom.x)*k
                rightBottom.y = rhsY
            }
            
            
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
            
            let rhsDistance = rhsTop.y - rhsBottom.y
            var topH = true, bottomH = true


            let topDistance = rhsTop.y - lhsTop.y
            if abs(topDistance) < limite{
                topH = false
            }
            let bottomDistance = rhsBottom.y - lhsBottom.y
            if abs(bottomDistance) < limite{
                bottomH = false
            }

            let k = (rhsTop.x - rhsBottom.x)/rhsDistance

            if topH{
                let ths = (rhsTop.x - lhsTop.x)/topDistance
                let x = (((lhsTop.y - newValue.y) * ths - lhsTop.x)*k + newValue.x * ths)/(ths - k)
                rightTop.x = x
                rightTop.y = (x + newValue.y * k - newValue.x)/k
            }
            else{
                rightTop.x = (lhsTop.y - newValue.y) * k + newValue.x
            }

            if bottomH{
                let bhs = (rhsBottom.x - lhsBottom.x)/bottomDistance
                let x = (((rhsBottom.y - newValue.y) * bhs - rhsBottom.x)*k + newValue.x * bhs)/(bhs - k)
                rightBottom.x = x
                rightBottom.y = (x + newValue.y * k - newValue.x)/k
            }
            else{
                rightBottom.x = (rhsBottom.y - newValue.y) * k + newValue.x
            }
            
            
        }
    }


    
    
    private
    func centerPoint(from fromPoint: CGPoint, to toPoint: CGPoint) -> CGPoint{
        return CGPoint(x: (fromPoint.x + toPoint.x)/2, y: (fromPoint.y + toPoint.y)/2)
    }
    
    
    
    
    init() {
        leftTop = CGPoint(x: 10, y: 10)
        
        rightTop = CGPoint(x: 100, y: 10)
        
        
        leftBottom = CGPoint(x: 10, y: 100)
        
        rightBottom = CGPoint(x: 100, y: 100)
    }
}
