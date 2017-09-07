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
    var contentScaleFactor: CGFloat          // set this from UIView's contentScaleFactor to position axes with maximum accuracy
    
    init(color: UIColor = UIColor.red, contentScaleFactor: CGFloat = 1) {
        self.color = color
        self.contentScaleFactor = contentScaleFactor
    }
    
    func drawALine(from: (x: CGFloat?, y: CGFloat?),
                   to: (x: CGFloat, y: CGFloat),
                   in rect: CGRect,
                   origin: CGPoint,
                   pointsPerUnit: CGFloat)
    {
        UIGraphicsGetCurrentContext()?.saveGState()
        color.set()
        let path = UIBezierPath()

        let newX = origin.x + to.x
        let newY = origin.y - to.y
        var oldX: CGFloat?
        var oldY: CGFloat?
        
        if from.x != nil && from.y !=  nil {
            oldX = origin.x + from.x!
            oldY = origin.y - from.y!
        }
        
        if ((newY.isNormal) || (newY.isZero)) && !(newY.isNaN) {
            if oldX == nil && oldY == nil || oldY!.isNaN || oldY!.isInfinite || newY.isNaN || newY.isInfinite {
                path.move(to: CGPoint(x: newX, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
                
            } else if (abs(newY / oldY!) > 300) {
                if newY > 0 && oldY! > 0 || newY < 0 && oldY! < 0 {
                    
                    
                    
                    path.move(to: CGPoint(x: oldX!, y: oldY!).aligned(usingScaleFactor: contentScaleFactor)!)
                    path.addLine(to: CGPoint(x: oldX!, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
                    path.stroke()
                    
                } else {
                    path.move(to: CGPoint(x: newX, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
                    
                }
                
            } else if ((oldY!.isNormal) || (oldY!.isZero)) && (oldY!.isFinite){
                path.move(to: CGPoint(x: oldX!, y: oldY!).aligned(usingScaleFactor: contentScaleFactor)!)
                path.addLine(to: CGPoint(x: newX, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
                path.stroke()
            }
        }
//        if ((newY.isNormal) || (newY.isZero)) && !(newY.isNaN) {
//            if oldX == nil && oldY == nil || oldY!.isNaN || oldY!.isInfinite || newY.isNaN || newY.isInfinite {
//                path.move(to: CGPoint(x: newX, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
//                
//            } else if (abs(newY / oldY!) > pointsPerUnit) {
//                if newY > 0 && oldY! > 0 || newY < 0 && oldY! < 0 {
//                    
//
//                    
//                    path.move(to: CGPoint(x: oldX!, y: oldY!).aligned(usingScaleFactor: contentScaleFactor)!)
//                    path.addLine(to: CGPoint(x: oldX!, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
//                    path.stroke()
//                    
//                } else {
//
//                    path.move(to: CGPoint(x: newX, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
//
//                }
//                
//            } else if ((oldY!.isNormal) || (oldY!.isZero)) && (oldY!.isFinite){
//                path.move(to: CGPoint(x: oldX!, y: oldY!).aligned(usingScaleFactor: contentScaleFactor)!)
//                path.addLine(to: CGPoint(x: newX, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
//                path.stroke()
//            }
//        }
        
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
}



