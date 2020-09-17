//
//  SketchView.swift
//  pointsDrag
//
//  Created by Jz D on 2020/9/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


enum SketchPointOption: Int{
    case leftTop = 0, rightTop = 1, leftBottom = 2
    case rightBottom = 3, centerLnTop = 4, centerLnLeft = 5
    case centerLnRight = 6, centerLnBottom = 7
    
    
}



class SketchView: UIView {

    var currentControlPointType: SketchPointOption? = nil{
        didSet{
            if let type = currentControlPointType{
                var pts = [defaultPoints.leftTop, defaultPoints.rightTop, defaultPoints.leftBottom,
                           defaultPoints.rightBottom, defaultPoints.lnTopCenter, defaultPoints.lnLeftCenter,
                           defaultPoints.lnRightCenter, defaultPoints.lnBottomCenter]
                pts.remove(at: type.rawValue)
                defaultPoints.restPoints = pts
            }
            else{
                defaultPoints.restPoints = []
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
    var ggFourSide = false
    
    var lastPoint: CGPoint?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.addSublayer(lineLayer)
        layer.addSublayer(pointsLayer)
        
        
        
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
        ggFourSide = false
        ggTouch = false
        lastPoint = nil
        guard let touch = touches.first else{
            return
        }
        
        
        let currentPoint = touch.location(in: self)
        
        // 判定选中的最大距离
        let maxDistance: CGFloat = 20
        let points = [defaultPoints.leftTop, defaultPoints.rightTop, defaultPoints.leftBottom,
                      defaultPoints.rightBottom, defaultPoints.lnTopCenter, defaultPoints.lnLeftCenter,
                      defaultPoints.lnRightCenter, defaultPoints.lnBottomCenter]
        for pt in points{
            let distance = abs(pt.x - currentPoint.x) + abs(pt.y - currentPoint.y)
            if distance <= maxDistance, let pointIndex = points.firstIndex(of: pt){
                currentControlPointType = SketchPointOption(rawValue: pointIndex)
                break
            }
        }
    }
    


    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let currentType = currentControlPointType, let touch = touches.first{
            let current = touch.location(in: self)
            guard bounds.contains(current) else{
                return
            }
   
            
            for pt in defaultPoints.restPoints{
                let distance = abs(pt.x - current.x) + abs(pt.y - current.y)
                if distance < 40{
                    ggTouch = true
                    break
                }
            }
            
            
            guard ggTouch == false else {
                
                return
            }
            
            
            switch currentType {
            case .leftTop:
                defaultPoints.leftTop = current
            case .rightTop:
                defaultPoints.rightTop = current
            case .leftBottom:
                defaultPoints.leftBottom = current
            case .rightBottom:
                defaultPoints.rightBottom = current
            case .centerLnTop:
                defaultPoints.lnTopCenter = current
            case .centerLnLeft:
                defaultPoints.lnLeftCenter = current
            case .centerLnRight:
                defaultPoints.lnRightCenter = current
            case .centerLnBottom:
                defaultPoints.lnBottomCenter = current
            }
            if defaultPoints.gimpTransformPolygonIsConvex == false{
                ggFourSide = true
            }
            guard ggFourSide == false else {
                if let last = lastPoint{
                    switch currentType {
                    case .leftTop:
                        defaultPoints.leftTop = last
                    case .rightTop:
                        defaultPoints.rightTop = last
                    case .leftBottom:
                        defaultPoints.leftBottom = last
                    case .rightBottom:
                        defaultPoints.rightBottom = last
                    case .centerLnTop:
                        defaultPoints.lnTopCenter = last
                    case .centerLnLeft:
                        defaultPoints.lnLeftCenter = last
                    case .centerLnRight:
                        defaultPoints.lnRightCenter = last
                    case .centerLnBottom:
                        defaultPoints.lnBottomCenter = last
                    }
                    
                    reloadData()
                }
                
                return
            }
            lastPoint = current
            reloadData()
        }
        
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        currentControlPointType = nil
        defaultPoints.doingParallel = false
        ggTouch = false
        ggFourSide = false
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        currentControlPointType = nil
        defaultPoints.doingParallel = false
        ggTouch = false
        ggFourSide = false
    }
}



extension CGPoint{

    func advance(_ offsetX: CGFloat = 0, y offsetY: CGFloat = 0) -> CGPoint{
        return CGPoint(x: x+offsetX, y: y+offsetY)
    }


}
