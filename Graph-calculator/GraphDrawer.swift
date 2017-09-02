//
//  GraphDrawer.swift
//  Draw-axes
//
//  Created by Kristina Gelzinyte on 8/25/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

struct GraphDrawer {

    var color: UIColor
    var contentScaleFactor: CGFloat             // set this from UIView's contentScaleFactor to position axes with maximum accuracy
    
    var memory = [String: Double]()
    var brain = CalculatorBrain()
    var arrayToCalculate = [String]()
    
    init(color: UIColor = UIColor.red, contentScaleFactor: CGFloat = 1) {
        self.color = color
        self.contentScaleFactor = contentScaleFactor
    }

    mutating func drawGraph(point: (Double, Double), in rect: CGRect, origin: CGPoint, pointsPerUnit: CGFloat)
    {
        UIGraphicsGetCurrentContext()?.saveGState()
        color.set()
        
        var y = 0.0
        var newX: CGFloat?
        var newY: CGFloat?
        var oldY: CGFloat?
        var oldX: CGFloat?
        
        let path = UIBezierPath()
        
        let start = Int(rect.minX)
        let end = Int(rect.maxX)
        

        
        for x in start...end {
            let scaledX = Double(x)/Double(pointsPerUnit)
            memory = ["M": scaledX]
            
            if let result = brain.evaluate(using: memory).result {
                y = result * Double(pointsPerUnit)
            }
            
//            y = sin(scaledX) * Double(pointsPerUnit)
            
            newY = CGFloat(y)
            newX = CGFloat(x)
            
            if ((newY!.isNormal) || (newY!.isZero)) && !(newY!.isNaN) {
                if oldX == nil && oldY == nil || (abs(newY!-oldY!) > 3000) {
                    path.move(to: CGPoint(x: origin.x + newX!, y: origin.y - newY!).aligned(usingScaleFactor: contentScaleFactor)!)
                } else if ((oldY!.isNormal) || (oldY!.isZero)) && (oldY!.isFinite){
                    path.move(to: CGPoint(x: origin.x + oldX!, y: origin.y - oldY!).aligned(usingScaleFactor: contentScaleFactor)!)
                    path.addLine(to: CGPoint(x: origin.x + newX!, y: origin.y - newY!).aligned(usingScaleFactor: contentScaleFactor)!)
                    path.stroke()
                }
            }

            oldY = newY
            oldX = newX
        }
        UIGraphicsGetCurrentContext()?.restoreGState()
    }


}
