//
//  SketchView.swift
//  pointsDrag
//
//  Created by Jz D on 2020/9/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


enum SketchPointOption: Int{
    case leftTop = 0, rightTop = 1, rightBottom = 2
    case leftBottom = 3, centerLnTop = 4, centerLnRight = 5
    case centerLnBottom = 6, centerLnLeft = 7
    
    
}



// 计时器分配资源，大法好


// 哪里能让用户，触发到那里，就去计算


class SketchView: UIView {

    var currentControlPointType: SketchPointOption? = nil{
        didSet{
            if let type = currentControlPointType{
                var corners = defaultPoints.corners
                var restPts = [CGPoint]()
                switch type {
                case .leftTop, .rightTop, .rightBottom,
                     .leftBottom:
                    corners.remove(at: type.rawValue)
                    restPts = corners
                case .centerLnLeft:
                    restPts = [defaultPoints.rightTop, defaultPoints.rightBottom]
                case .centerLnTop:
                    restPts = [defaultPoints.rightBottom, defaultPoints.leftBottom]
                case .centerLnBottom:
                    restPts = [defaultPoints.leftTop, defaultPoints.rightTop]
                case .centerLnRight:
                    restPts = [defaultPoints.leftTop, defaultPoints.leftBottom]
                }
                defaultPoints.restCorners = restPts
                defaultPoints.nearCorners = corners.filter({  restPts.contains($0) == false  })
            }
            else{
                defaultPoints.restCorners = []
                defaultPoints.nearCorners = []
            }
        }
    }
    
    var lineLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        l.fillColor = UIColor.clear.cgColor
        l.strokeColor = UIColor.red.cgColor
        return l
    }()
    
    var pointsLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        l.fillColor = UIColor.white.cgColor
        l.strokeColor = UIColor.red.cgColor
        return l
    }()
    
    var linePath: UIBezierPath = {
        let l = UIBezierPath()
        l.lineWidth = 2
        return l
    }()
    
    var pointPath: UIBezierPath = {
        let l = UIBezierPath()
        l.lineWidth = 2
        return l
    }()
    
    
    var defaultPoints = SketchModel()
    
    var ggTouch = false

    

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.addSublayer(lineLayer)
        layer.addSublayer(pointsLayer)
        
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 2
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineLayer.frame = bounds
        pointsLayer.frame = bounds
        
    }
    
    
    
    
    /**
     刷新数据
     */
    func reloadData(){
        linePath.removeAllPoints()
        pointPath.removeAllPoints()
        draw(sketch: defaultPoints)
        
       
        lineLayer.path = linePath.cgPath
        pointsLayer.path = pointPath.cgPath
    }
    
    
    /**
     绘制单个图形
     */
    func draw(sketch model: SketchModel){
        drawLine(with: model)
        drawPoints(with: model)
    }

    
    
    
    
    /**
      绘制四条边
     */
    func drawLine(with sketch: SketchModel){
        linePath.move(to: sketch.leftTop)
        linePath.addLine(to: sketch.rightTop)
        linePath.addLine(to: sketch.rightBottom)
        linePath.addLine(to: sketch.leftBottom)
        linePath.close()
        
    }
    
    
    
    
    /**
     绘制四个顶点
     */
    func drawPoints(with sketch: SketchModel){
        let radius: CGFloat = 8
        pointPath.move(to: sketch.leftTop.advance(radius))
        pointPath.addArc(withCenter: sketch.leftTop, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        pointPath.move(to: sketch.rightTop.advance(radius))
        pointPath.addArc(withCenter: sketch.rightTop, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        pointPath.move(to: sketch.rightBottom.advance(radius))
        pointPath.addArc(withCenter: sketch.rightBottom, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        pointPath.move(to: sketch.leftBottom.advance(radius))
        pointPath.addArc(withCenter: sketch.leftBottom, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        ///
        
        pointPath.move(to: sketch.lnTopCenter.advance(radius))
        pointPath.addArc(withCenter: sketch.lnTopCenter, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        pointPath.move(to: sketch.lnLeftCenter.advance(radius))
        pointPath.addArc(withCenter: sketch.lnLeftCenter, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        pointPath.move(to: sketch.lnRightCenter.advance(radius))
        pointPath.addArc(withCenter: sketch.lnRightCenter, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        pointPath.move(to: sketch.lnBottomCenter.advance(radius))
        pointPath.addArc(withCenter: sketch.lnBottomCenter, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        defaultPoints.doingParallel = false
        ggTouch = false

        guard let touch = touches.first else{
            return
        }
        
        
        let currentPoint = touch.location(in: self)
        
        // 判定选中的最大距离
      //  let points = defaultPoints.corners
        let points = defaultPoints.corners +
                     [defaultPoints.lnTopCenter, defaultPoints.lnRightCenter,
                     defaultPoints.lnBottomCenter, defaultPoints.lnLeftCenter]
        
        var first = true
        // from, current, 0
        var mini = (CGPoint.zero, CGPoint.zero, CGFloat.zero)
        for pt in points{
            let distance = abs(pt.x - currentPoint.x) + abs(pt.y - currentPoint.y)
            
            
            if first{
                mini = (pt, currentPoint, distance)
                first = false
            }
            else{
                if distance < mini.2{
                    mini = (pt, currentPoint, distance)
                }
            }
            
            
            if distance <= SketchConst.std.radius, let pointIndex = points.firstIndex(of: pt){
                currentControlPointType = SketchPointOption(rawValue: pointIndex)
                break
            }
        }
        print(mini)
    }
    


    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let currentType = currentControlPointType, let touch = touches.first{
            let current = touch.location(in: self)
            guard bounds.contains(current) else{
                return
            }
   
            
            
            var thisSidePrePts = [CGPoint](), antiSidePts = [CGPoint]()
            let corners = defaultPoints.oldCorners
            
            switch currentType {
            case .leftTop, .rightTop, .rightBottom,
                .leftBottom:
                  for pt in defaultPoints.restCorners{
                      let distance = abs(pt.x - current.x) + abs(pt.y - current.y)
                      if distance < SketchConst.std.distance{
                          ggTouch = true
                          break
                      }
                  
                  }
            
            case .centerLnTop:
                if corners.count == 4 {
                    let pts = current.calculateTopCenter(lhsTopP: corners[0], rhsTopP: corners[1],rhsBottomP: corners[2], lhsBottomP: corners[3])
                    thisSidePrePts.append(contentsOf: [pts.0, pts.1])
                    antiSidePts.append(contentsOf: [corners[2], corners[3]])
                }
            case .centerLnLeft:
                if corners.count == 4 {
                    let pts = current.calculateLeftCenter(lhsTopP: corners[0], rhsTopP: corners[1],rhsBottomP: corners[2], lhsBottomP: corners[3])
                    thisSidePrePts.append(contentsOf: [pts.0, pts.1])
                    antiSidePts.append(contentsOf: [corners[1], corners[2]])
                }
            case .centerLnRight:
                if corners.count == 4 {
                    let pts = current.calculateRightCenter(lhsTopP: corners[0], rhsTopP: corners[1],rhsBottomP: corners[2], lhsBottomP: corners[3])
                    thisSidePrePts.append(contentsOf: [pts.0, pts.1])
                    antiSidePts.append(contentsOf: [corners[0], corners[3]])
                }
            case .centerLnBottom:
                if corners.count == 4 {
                    let pts = current.calculateBottomCenter(lhsTopP: corners[0], rhsTopP: corners[1],rhsBottomP: corners[2], lhsBottomP: corners[3])
                    thisSidePrePts.append(contentsOf: [pts.0, pts.1])
                    antiSidePts.append(contentsOf: [corners[0], corners[1]])
                }
            }
            if thisSidePrePts.isEmpty == false{
                print("A")
                for pt in antiSidePts{
                     let distanceA = abs(pt.x - thisSidePrePts[0].x) + abs(pt.y - thisSidePrePts[0].y)
                     let distanceB = abs(pt.x - thisSidePrePts[1].x) + abs(pt.y - thisSidePrePts[1].y)
                     if distanceA < SketchConst.std.distance || distanceB < SketchConst.std.distance{
                         ggTouch = true
                         break
                     }
                }
                 
                
            }

            
            
            guard ggTouch == false else {
                
                return
            }
            
            
            switch currentType {
            case .leftTop:
                print(1)
                defaultPoints.leftTop = current
            case .rightTop:
                print(2)
                defaultPoints.rightTop = current
            case .leftBottom:
                print(3)
                defaultPoints.leftBottom = current
            case .rightBottom:
                print(4)
                defaultPoints.rightBottom = current
            case .centerLnTop:
                print(5)
                defaultPoints.lnTopCenter = current
            case .centerLnLeft:
                print(6)
                defaultPoints.lnLeftCenter = current
            case .centerLnRight:
                print(7)
                defaultPoints.lnRightCenter = current
            case .centerLnBottom:
                print(8)
                defaultPoints.lnBottomCenter = current
            }
          
            reloadData()
        }
        
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        currentControlPointType = nil
        defaultPoints.doingParallel = false
        ggTouch = false

    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        currentControlPointType = nil
        defaultPoints.doingParallel = false
        ggTouch = false

    }
}



extension CGPoint{

    func advance(_ offsetX: CGFloat = 0, y offsetY: CGFloat = 0) -> CGPoint{
        return CGPoint(x: x+offsetX, y: y+offsetY)
    }


}
