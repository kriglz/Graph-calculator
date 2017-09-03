//
//  GraphView.swift
//
//  Created by Kristina Gelzinyte on 8/23/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class GraphView: UIView {

    let scaleConstant = 30  //use 40 pixels to make 1 unit
    var functionY: ((_ xArgument: Double) -> Double)?

    
    override func draw(_ rect: CGRect) {
        let axes: AxesDrawer =  AxesDrawer.init(color: UIColor.blue, contentScaleFactor: CGFloat(1))
        let centerCoordinate = CGPoint(x: bounds.midX, y: bounds.midY)

        //top right
        axes.drawAxes(in: CGRect(origin: centerCoordinate,
                                 size: CGSize(width: bounds.midX, height: -bounds.midY)),
                      origin: centerCoordinate,
                      pointsPerUnit: CGFloat(scaleConstant))
        
        //bottom right
        axes.drawAxes(in: CGRect(origin: centerCoordinate,
                                 size: CGSize(width: bounds.midX, height: bounds.midY)),
                      origin: centerCoordinate,
                      pointsPerUnit: CGFloat(scaleConstant))
        
        //top left
        axes.drawAxes(in: CGRect(origin: centerCoordinate,
                                 size: CGSize(width: -bounds.midX, height: -bounds.midY)),
                      origin: centerCoordinate,
                      pointsPerUnit: CGFloat(scaleConstant))

        //botton left
        axes.drawAxes(in: CGRect(origin: centerCoordinate,
                                 size: CGSize(width: -bounds.midX, height: bounds.midY)),
                      origin: centerCoordinate,
                      pointsPerUnit: CGFloat(scaleConstant))
        
        
        
        //draw function
        let graph: GraphDrawer = GraphDrawer.init(color: UIColor.red, contentScaleFactor: CGFloat(1))
        
        let start = Int(-rect.maxX/2)
        let end = Int(rect.maxX/2)
        
        print(start, end)
        print(rect.origin.x, rect.origin.y)
        
        var scaledX: Double?
        var y: Double?
        var oldX: CGFloat?
        var oldY: CGFloat?
        
        for x in start...end {
            scaledX = Double(x)/Double(scaleConstant)
            y = functionY!(scaledX!) * Double(scaleConstant)

            graph.drawGraph(from: (oldX, oldY),
                            to: (CGFloat(x), CGFloat(y!)),
                            in: rect,

//                            in: CGRect(origin: CGPoint(x: bounds.midX, y: bounds.midY),
//                                       size: CGSize(width: -2*bounds.midX,
//                                                    height: -2*bounds.midY)),
                            origin: centerCoordinate,
                            pointsPerUnit: CGFloat(scaleConstant))

            oldX = CGFloat(x)
            oldY = CGFloat(y!)
            
        }

        
        
    }

}




