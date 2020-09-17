//
//  SketchModel.swift
//  pointsDrag
//
//  Created by Jz D on 2020/9/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit



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
            
            
            if lhsV{
                let w = (lhsTop.y - lhsBottom.y)/lhsDistance
                let y = (((lhsBottom.x - newValue.x) * k + newValue.y) * w - lhsBottom.y * k)/(w - k)
                leftTop.y = y
                leftTop.x = (y + newValue.x * k - newValue.y)/k
            }
            else{
                let y = (lhsBottom.x - newValue.x) * k + newValue.y
                leftTop.y = y
            }
            
                
            
            
            
            
            if rhsV{
                let rhs = (rhsTop.y - rhsBottom.y)/rhsDistance
                let rhsY = (k * rhsTop.y + ((newValue.x - rhsTop.x)*k - newValue.y) * rhs)/(k - rhs)
                rightTop.y = rhsY
                rightTop.x = (rhsY + newValue.x * k - newValue.x)/k
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
            
            
            let lhsDistance = leftTop.y - leftBottom.y
            var topH = true, bottomH = true
            
            
            let topDistance = rightTop.y - leftTop.y
            if abs(topDistance) < limite{
                topH = false
            }
            let bottomDistance = rightBottom.y - leftBottom.y
            if abs(bottomDistance) < limite{
                bottomH = false
            }

            let k = (leftTop.x - leftBottom.x)/lhsDistance
                        
            if topH{
                let ths = (rightTop.x - leftTop.x)/topDistance
                let x = (((rightTop.y - newValue.y) * ths - rightTop.x)*k + newValue.x * ths)/(ths - k)
                leftTop.x = x
                leftTop.y = (x + newValue.y * k - newValue.x)/k
            }
            else{
                leftTop.x = (rightTop.y - newValue.y) * k + newValue.x
            }
            
            if bottomH{
                let bhs = (rightBottom.x - leftBottom.x)/bottomDistance
                let x = (((rightBottom.y - newValue.y) * bhs - rightBottom.x)*k + newValue.x * bhs)/(bhs - k)
                leftBottom.x = x
                leftBottom.y = (x + newValue.y * k - newValue.x)/k
            }
            else{
                leftBottom.x = (rightBottom.y - newValue.y) * k + newValue.x
            }
            
            
        }
    }

    
    
    var lnBottomCenter: CGPoint{
        get{
            centerPoint(from: leftBottom, to: rightBottom)
        }
        set{
            
            doingParallel = true
            
            
            
            let bottomDistance = rightBottom.x - leftBottom.x
            var lhsV = true, rhsV = true
            
            let lhsDistance = leftTop.x - leftBottom.x
            if abs(lhsDistance) < limite{
                lhsV = false
            }
            let rhsDistance = rightTop.x - rightBottom.x
            if abs(rhsDistance) < limite{
                rhsV = false
            }
            
            let k = (rightBottom.y - leftBottom.y)/bottomDistance
            
            if lhsV{
                let w = (leftTop.y - leftBottom.y)/lhsDistance
                let y = (((leftBottom.x - newValue.x) * k + newValue.y) * w - leftBottom.y * k)/(w - k)
                leftBottom.y = y
                leftBottom.x = (y + newValue.x * k - newValue.y)/k
            }
            else{
                let y = (leftBottom.x - newValue.x) * k + newValue.y
                leftBottom.y = y
            }
            
                
            
            
            
            
            if rhsV{
                let rhs = (rightTop.y - rightBottom.y)/rhsDistance
                let rhsY = (k * rightBottom.y + ((newValue.x - rightBottom.x)*k - newValue.y) * rhs)/(k - rhs)
                rightBottom.y = rhsY
                rightBottom.x = (rhsY + newValue.x * k - newValue.x)/k
            }
            else{
                let rhsY = newValue.y - (newValue.x - rightBottom.x)*k
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
            
            
            let rhsDistance = rightTop.y - rightBottom.y
            var topH = true, bottomH = true


            let topDistance = rightTop.y - leftTop.y
            if abs(topDistance) < limite{
                topH = false
            }
            let bottomDistance = rightBottom.y - leftBottom.y
            if abs(bottomDistance) < limite{
                bottomH = false
            }

            let k = (rightTop.x - rightBottom.x)/rhsDistance

            if topH{
                let ths = (rightTop.x - leftTop.x)/topDistance
                let x = (((leftTop.y - newValue.y) * ths - leftTop.x)*k + newValue.x * ths)/(ths - k)
                rightTop.x = x
                rightTop.y = (x + newValue.y * k - newValue.x)/k
            }
            else{
                rightTop.x = (leftTop.y - newValue.y) * k + newValue.x
            }

            if bottomH{
                let bhs = (rightBottom.x - leftBottom.x)/bottomDistance
                let x = (((rightBottom.y - newValue.y) * bhs - rightBottom.x)*k + newValue.x * bhs)/(bhs - k)
                rightBottom.x = x
                rightBottom.y = (x + newValue.y * k - newValue.x)/k
            }
            else{
                rightBottom.x = (rightBottom.y - newValue.y) * k + newValue.x
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
