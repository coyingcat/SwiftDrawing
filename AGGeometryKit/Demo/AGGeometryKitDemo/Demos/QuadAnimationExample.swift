//
//  QuadAnimationExample.swift
//  AGGeometryKit
//
//  Created by Håvard Fossli on 21/07/15.
//  Copyright (c) 2015 H√•vard Fossli. All rights reserved.
//

import Foundation
import UIKit
import AGGeometryKit

class QuadAnimationExample: UIViewController {
    
    @IBOutlet var imageView:UIImageView?
    var originalQuad:AGKQuad = AGKQuadZero
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let source = imageView {
            source.layer.ensureAnchorPointIsSetToZero()
            originalQuad = source.layer.quadrilateral
        }
    }
    
    @IBAction func changeToSquareShape() {
        animateToQuad(originalQuad)
    }
    
    @IBAction func changeToOddShape1() {
        var quad = originalQuad;
        quad.tr.y += 70;
        quad.tr.x -= 20;
        quad.br.x += 10;
        quad.br.y -= 30;
        quad.bl.x -= 40;
        quad.tl.x += 40;
        animateToQuad(quad)
    }
    
    @IBAction func changeToOddShape2() {
        var quad = self.originalQuad;
        quad.tr.y -= 125;
        quad.br.y += 65;
        quad.bl.x += 40;
        quad.tl.x -= 40;
        animateToQuad(quad)
    }
    
    @IBAction func tapRecognized(_ recognizer: UITapGestureRecognizer) {
        NSLog("Tap recognized. Logging just to show that we are receiving touch correctly even when animating.");
    }
    
    fileprivate func animateToQuad(_ quad: AGKQuad) {
        
        print("Animating from: \(String(describing: NSStringFromAGKQuad(imageView!.layer.quadrilateral)))")
        print("Animating to: \(String(describing: NSStringFromAGKQuad(quad)))")
        
        let duration:TimeInterval = 2.0
        
        let ease: (_ p: Double) -> Double = {
            return Double(ElasticEaseOut(Float($0)))
        }
        
        let onComplete: (_ completed: Bool) -> Void = {
            let state = $0 ? "FINISHED" : "CANCELLED"
            NSLog("Animation done \(state)")
        }
        
        imageView!.layer.animateFromPresentedState(toQuadrilateral: quad,
            forNumberOfFrames: UInt(duration * 60),
            duration: duration,
            delay: 0.0,
            animKey: "demo",
            easeFunction: ease,
            onComplete: onComplete
        )
    }
}
