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
    case rightBottom = 3
    
    
}



class SketchView: UIView {

    var currentControlPointType: SketchPointOption? = nil{
        didSet{
            if let type = currentControlPointType{
                var pts = [defaultPoints.leftTop, defaultPoints.rightTop, defaultPoints.leftBottom,
                           defaultPoints.rightBottom]
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
     
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)

        ggTouch = false

        guard let touch = touches.first else{
            return
        }
        
        
        let currentPoint = touch.location(in: self)
        
        // 判定选中的最大距离
        let maxDistance: CGFloat = 20
        let points = [defaultPoints.leftTop, defaultPoints.rightTop, defaultPoints.leftBottom,
                      defaultPoints.rightBottom]
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
        if currentControlPointType != nil, let touch = touches.first{
            let current = touch.location(in: self)
            guard bounds.contains(current) else{
                return
            }
   
            
            let points = defaultPoints.restPoints + [current]
            var ptCount = points.count
            for i in 0...(ptCount - 2){
                for j in (i + 1)...(ptCount - 1){
                    let lhs = points[i]
                    let rhs = points[j]
                    let distance = abs(lhs.x - rhs.x) + abs(lhs.y - rhs.y)
                    if distance < 40{
                        ggTouch = true
                        break
                    }
                }
            }
            
            ptCount = defaultPoints.restPoints.count - 1
            for i in 0...(ptCount - 2){
                for j in (i + 1)...(ptCount - 1){
                    let lhs = points[i]
                    let rhs = points[j]
                    let oneDistance = rhs.x - lhs.x
                    let twoDistance = current.x - lhs.x
                    if abs(oneDistance) < 5 , abs(twoDistance) < 5{
                        ggTouch = true
                        break
                    }
                    else{
                        let offset = (rhs.y - lhs.y)/oneDistance - (current.y - lhs.y)/twoDistance
                        if abs(offset) < 0.1{
                            ggTouch = true
                            break
                        }
                    }
                }
            }
            
            
            guard ggTouch == false else {
                
                return
            }
            
            
            prepare(point: current)
         
            reloadData()
        }
        
    }

    
    func prepare(point pt: CGPoint){
        if let type = currentControlPointType{
            switch type {
            case .leftTop:
                defaultPoints.leftTop = pt
            case .rightTop:
                defaultPoints.rightTop = pt
            case .leftBottom:
                defaultPoints.leftBottom = pt
            case .rightBottom:
                defaultPoints.rightBottom = pt
            }
        }
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        currentControlPointType = nil
        ggTouch = false

    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        currentControlPointType = nil
        ggTouch = false
 
    }
}



extension CGPoint{

    func advance(_ offsetX: CGFloat = 0, y offsetY: CGFloat = 0) -> CGPoint{
        return CGPoint(x: x+offsetX, y: y+offsetY)
    }


}
