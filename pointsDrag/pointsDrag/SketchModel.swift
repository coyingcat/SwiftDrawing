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
    
    
    let limite: CGFloat = 0.03
    
    
    var lnTopCenter: CGPoint{
        get{
            centerPoint(from: leftTop, to: rightTop)
        }
        set{
            let topDistance = rightTop.x - leftTop.x
            var lhsV = true, rhsV = true
            
            
            
            let lhsDistance = leftTop.x - leftBottom.x
            if abs(lhsDistance) < limite{
                lhsV = false
            }
            let rhsDistance = rightTop.x - rightBottom.x
            if abs(rhsDistance) < limite{
                rhsV = false
            }
            
            
            
            let k = (rightTop.y - leftTop.y)/topDistance
            
            
            if lhsV{
                let w = (leftTop.y - leftBottom.y)/lhsDistance
                let y = (((leftBottom.x - newValue.x) * k + newValue.y) * w - leftBottom.y * k)/(w - k)
                leftTop.y = y
                leftTop.x = (y + newValue.x * k - newValue.y)/k
            }
            else{
                let y = (leftBottom.x - newValue.x) * k + newValue.y
                leftTop.y = y
            }
            
                
            
            
            
            
            if rhsV{
                let rhs = (rightTop.y - rightBottom.y)/rhsDistance
                let rhsY = (k * rightTop.y + ((newValue.x - rightTop.x)*k - newValue.y) * rhs)/(k - rhs)
                rightTop.y = rhsY
                rightTop.x = (rhsY + newValue.x * k - newValue.x)/k
            }
            else{
                let rhsY = newValue.y - (newValue.x - rightTop.x)*k
                rightTop.y = rhsY
            }
            
            
        }
    }

  
    var lnLeftCenter: CGPoint{
        get{
            centerPoint(from: leftTop, to: leftBottom)
        }
        set{
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
                leftTop.x = (y + newValue.x * k - newValue.y)/k
            }
            else{
                let y = (leftBottom.x - newValue.x) * k + newValue.y
                leftBottom.y = y
            }
            
                
            
            
            
            
            if rhsV{
                let rhs = (rightTop.y - rightBottom.y)/rhsDistance
                let rhsY = (k * rightTop.y + ((newValue.x - rightTop.x)*k - newValue.y) * rhs)/(k - rhs)
                rightTop.y = rhsY
                rightTop.x = (rhsY + newValue.x * k - newValue.x)/k
            }
            else{
                let rhsY = newValue.y - (newValue.x - rightTop.x)*k
                rightTop.y = rhsY
            }
            
            
        }
    }

    
    
    var lnRightCenter: CGPoint{
        get{
            centerPoint(from: rightTop, to: rightBottom)
        }
        set{
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
