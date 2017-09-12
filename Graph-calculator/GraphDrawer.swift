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
        
        if oldX == nil || oldY == nil {
//            path.move(to: CGPoint(x: newX, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
            
        } else {
            path.move(to: CGPoint(x: oldX!, y: oldY!).aligned(usingScaleFactor: contentScaleFactor)!)
            path.addLine(to: CGPoint(x: newX, y: newY).aligned(usingScaleFactor: contentScaleFactor)!)
            path.stroke()
        }
        
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
}



