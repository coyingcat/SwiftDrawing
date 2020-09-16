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
    
    
    
    var lnTopCenter: CGPoint{
        get{
            centerPoint(from: leftTop, to: rightTop)
        }
        
    }

  
    var lnLeftCenter: CGPoint{
        get{
            centerPoint(from: leftTop, to: leftBottom)
        }
        
    }

    
    
    var lnBottomCenter: CGPoint{
        get{
            centerPoint(from: leftBottom, to: rightBottom)
        }
        
    }

    var lnRightCenter: CGPoint{
        get{
            centerPoint(from: rightTop, to: rightBottom)
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
