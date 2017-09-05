//
//  GraphView.swift
//
//  Created by Kristina Gelzinyte on 8/23/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {

    @IBInspectable
    var scaleConstant: Int = 30 { didSet { setNeedsDisplay()}} //use 30 pixels to make 1 unit
    
    var functionY: ((_ xArgument: Double) -> Double)?

    
    override func draw(_ rect: CGRect) {
        let axe = AxesDrawer.init(color: UIColor.blue, contentScaleFactor: CGFloat(1))
        let centerCoordinate = CGPoint(x: bounds.midX, y: bounds.midY)

        //top right
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                 size: CGSize(width: bounds.midX, height: -bounds.midY)),
                      origin: centerCoordinate,
                      pointsPerUnit: CGFloat(scaleConstant))
        
        //bottom right
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                 size: CGSize(width: bounds.midX, height: bounds.midY)),
                      origin: centerCoordinate,
                      pointsPerUnit: CGFloat(scaleConstant))
        
        //top left
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                 size: CGSize(width: -bounds.midX, height: -bounds.midY)),
                      origin: centerCoordinate,
                      pointsPerUnit: CGFloat(scaleConstant))

        //botton left
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                 size: CGSize(width: -bounds.midX, height: bounds.midY)),
                      origin: centerCoordinate,
                      pointsPerUnit: CGFloat(scaleConstant))
        
        
        
        //draw function
        let functionGraph = GraphDrawer.init(color: UIColor.red, contentScaleFactor: CGFloat(1))
        
        let start = Int(-rect.maxX/2)
        let end = Int(rect.maxX/2)
        
        var scaledNewX: Double?
        var newY: Double?
        var oldX: CGFloat?
        var oldY: CGFloat?
        
        for newX in start...end {
            scaledNewX = Double(newX)/Double(scaleConstant)
            
            if let function = functionY {
                newY = function(scaledNewX!) * Double(scaleConstant)
                
                functionGraph.drawALine(from: (oldX, oldY),
                                        to: (CGFloat(newX), CGFloat(newY!)),
                                        in: rect,
                                        origin: centerCoordinate,
                                        pointsPerUnit: CGFloat(scaleConstant))
                
                oldX = CGFloat(newX)
                oldY = CGFloat(newY!)
            }
        }
    }
}




