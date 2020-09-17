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
    case leftBottom = 3, centerLnTop = 4, centerLnLeft = 5
    case centerLnRight = 6, centerLnBottom = 7
    
    
}



class SketchView: UIView {

    var currentControlPointType: SketchPointOption?
    
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
        
        
        guard let touch = touches.first else{
            return
        }
        let currentPoint = touch.location(in: self)
        
        // 判定选中的最大距离
        let maxDistance: CGFloat = 20
        let points = [defaultPoints.leftTop, defaultPoints.rightTop, defaultPoints.rightBottom,
                      defaultPoints.leftBottom, defaultPoints.lnTopCenter, defaultPoints.lnLeftCenter,
                      defaultPoints.lnRightCenter, defaultPoints.lnBottomCenter]
        for pt in points{
            let distance = sqrt(pow(pt.x - currentPoint.x, 2) + pow(pt.y - currentPoint.y, 2))
            if distance <= maxDistance, let pointIndex = points.firstIndex(of: pt){
                currentControlPointType = SketchPointOption(rawValue: pointIndex)
                break
            }
        }
    }
    


    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let current = currentControlPointType, let touch = touches.first{
            let pt = touch.location(in: self)
            guard bounds.contains(pt) else{
                return
            }
            switch current {
            case .leftTop:
                defaultPoints.leftTop = pt
            case .rightTop:
                defaultPoints.rightTop = pt
            case .leftBottom:
                defaultPoints.leftBottom = pt
            case .rightBottom:
                defaultPoints.rightBottom = pt
            case .centerLnTop:
                defaultPoints.lnTopCenter = pt
            case .centerLnLeft:
                defaultPoints.lnLeftCenter = pt
            case .centerLnRight:
                defaultPoints.lnRightCenter = pt
            case .centerLnBottom:
                defaultPoints.lnBottomCenter = pt
            }
            reloadData()
        }
        
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        currentControlPointType = nil
        defaultPoints.doingParallel = false
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        currentControlPointType = nil
        defaultPoints.doingParallel = false
    }
}



extension CGPoint{

    func advance(_ offsetX: CGFloat = 0, y offsetY: CGFloat = 0) -> CGPoint{
        return CGPoint(x: x+offsetX, y: y+offsetY)
    }


}
