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
    var scaleConstant: Double = 30.0 { didSet { setNeedsDisplay()}} //use 30 pixels to make 1 unit
    
    var translationCoordinate: CGPoint? { didSet { setNeedsDisplay()}}
    var functionY: ((_ xArgument: Double) -> Double)?

    
    override func draw(_ rect: CGRect) {
        let axe = AxesDrawer.init(color: UIColor.blue, contentScaleFactor: CGFloat(1))
        var centerCoordinate = CGPoint(x: bounds.midX, y: bounds.midY)
        
        if let translationCoordinates = translationCoordinate {
            centerCoordinate.x += translationCoordinates.x
            centerCoordinate.y += translationCoordinates.y
        }

//        print(rect.minX, rect.minY)
//        print(centerCoordinate.x, centerCoordinate.y)
        
        //top right
//        axe.drawAxes(in: CGRect(origin: centerCoordinate,
//                                 size: CGSize(width: bounds.midX, height: -bounds.midY)),
//                      origin: centerCoordinate,
//                      pointsPerUnit: CGFloat(scaleConstant))
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                size: CGSize(width: rect.maxX - centerCoordinate.x, height: centerCoordinate.y)),
                     origin: centerCoordinate,
                     pointsPerUnit: CGFloat(scaleConstant))
        
        //bottom right
//        axe.drawAxes(in: CGRect(origin: centerCoordinate,
//                                 size: CGSize(width: bounds.midX, height: bounds.midY)),
//                      origin: centerCoordinate,
//                      pointsPerUnit: CGFloat(scaleConstant))
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                size: CGSize(width: rect.minX - centerCoordinate.x, height: rect.maxY - centerCoordinate.y)),
                     origin: centerCoordinate,
                     pointsPerUnit: CGFloat(scaleConstant))
        
        //top left
//        axe.drawAxes(in: CGRect(origin: centerCoordinate,
//                                 size: CGSize(width: -bounds.midX, height: -bounds.midY)),
//                      origin: centerCoordinate,
//                      pointsPerUnit: CGFloat(scaleConstant))
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                size: CGSize(width: rect.minX + centerCoordinate.x, height: -centerCoordinate.y)),
                     origin: centerCoordinate,
                     pointsPerUnit: CGFloat(scaleConstant))


        //botton left
//        axe.drawAxes(in: CGRect(origin: centerCoordinate,
//                                 size: CGSize(width: -bounds.midX, height: bounds.midY)),
//                      origin: centerCoordinate,
//                      pointsPerUnit: CGFloat(scaleConstant))
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                size: CGSize(width: rect.minX + centerCoordinate.x, height: rect.maxY - centerCoordinate.y)),
                     origin: centerCoordinate,
                     pointsPerUnit: CGFloat(scaleConstant))

        
        
        
        //draw function
        let functionGraph = GraphDrawer.init(color: UIColor.red, contentScaleFactor: CGFloat(1))
        
        var start = Int(-rect.maxX/2)
        var end = Int(rect.maxX/2)
        
        if let translationCordinates = translationCoordinate {
            start -= Int(translationCordinates.x)
            end -= Int(translationCordinates.x)
        }
        
        
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
    
    // handler
    func changeScale (byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scaleConstant *= Double(pinchRecognizer.scale)
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    func changePosition (byReactingTo panRecognizer: UIPanGestureRecognizer)
    {        
        switch panRecognizer.state {
        case .changed:
            translationCoordinate = panRecognizer.translation(in: self)
        case  .ended:
            panRecognizer.setTranslation(CGPoint.zero, in: self)
        default:
            break
        }
    }
}




