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
    
    var sumOfTransitions: CGPoint = CGPoint(x: 0.0, y: 0.0) { didSet { setNeedsDisplay()}}
    
    
    override func draw(_ rect: CGRect) {
        let axe = AxesDrawer.init(color: UIColor.lightGray, contentScaleFactor: CGFloat(1))
        var centerCoordinate: CGPoint = CGPoint(x: bounds.maxX/2, y: bounds.maxY/2)
       

        if let translationCoordinates = translationCoordinate {
            sumOfTransitions.x += translationCoordinates.x
            sumOfTransitions.y += translationCoordinates.y
            
            centerCoordinate.x += sumOfTransitions.x
            centerCoordinate.y += sumOfTransitions.y
        }
        
        //top right
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                size: CGSize(width: rect.maxX - centerCoordinate.x, height: -centerCoordinate.y)),
                     origin: centerCoordinate,
                     pointsPerUnit: CGFloat(scaleConstant))
        
        //bottom right
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                size: CGSize(width: rect.maxX - centerCoordinate.x, height: rect.maxY - centerCoordinate.y)),
                     origin: centerCoordinate,
                     pointsPerUnit: CGFloat(scaleConstant))
        
        //top left
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                size: CGSize(width: -centerCoordinate.x, height: -centerCoordinate.y)),
                     origin: centerCoordinate,
                     pointsPerUnit: CGFloat(scaleConstant))


        //botton left
        axe.drawAxes(in: CGRect(origin: centerCoordinate,
                                size: CGSize(width: -centerCoordinate.x, height: rect.maxY - centerCoordinate.y)),
                     origin: centerCoordinate,
                     pointsPerUnit: CGFloat(scaleConstant))
        
        
        //draw function
        let functionGraph = GraphDrawer.init(color: UIColor.init(red: 255/225, green: 73/255, blue: 94/255, alpha: 1), contentScaleFactor: CGFloat(1))
        
        let start = Int(-rect.maxX/2) - Int(sumOfTransitions.x)
        let end = Int(rect.maxX/2) - Int(sumOfTransitions.x)
        
        var scaledNewX: Double?
        var newY: Double?
        var oldX: CGFloat?
        var oldY: CGFloat?
        var wasInfinite = false
        
        
        for newX in start...end {
            scaledNewX = Double(newX)/Double(scaleConstant)
            
            if let function = functionY {
                newY = function(scaledNewX!) * Double(scaleConstant)
                
                if let oldY = oldY, newY!.isInfinite {
                    newY = Double(oldY) * 1000000000.0
                    functionGraph.drawALine(from: (oldX, oldY),
                                            to: (oldX!, CGFloat(newY!)),
                                            in: rect,
                                            origin: centerCoordinate,
                                            pointsPerUnit: CGFloat(scaleConstant))
                    wasInfinite = true
                    
                } else if wasInfinite {
                    newY = newY! * 1000000000.0
                    wasInfinite = false
                    
                } else {
                    if let oldY = oldY {
                        if abs(Double(oldY) - newY!) < 1*scaleConstant {
                            functionGraph.drawALine(from: (oldX, oldY),
                                                    to: (CGFloat(newX), CGFloat(newY!)),
                                                    in: rect,
                                                    origin: centerCoordinate,
                                                    pointsPerUnit: CGFloat(scaleConstant))
                        } else {
                            if (Double(oldY) > 0 && newY! < 0) || (Double(oldY) < 0 && newY! > 0) {
                                
                                let newYTemp = Double(oldY) * 1000000000.0
                                functionGraph.drawALine(from: (oldX, oldY),
                                                        to: (oldX!, CGFloat(newYTemp)),
                                                        in: rect,
                                                        origin: centerCoordinate,
                                                        pointsPerUnit: CGFloat(scaleConstant))
                                wasInfinite = true
                            } else {
                                functionGraph.drawALine(from: (oldX, oldY),
                                                        to: (CGFloat(newX), CGFloat(newY!)),
                                                        in: rect,
                                                        origin: centerCoordinate,
                                                        pointsPerUnit: CGFloat(scaleConstant))
                            }
                        }
                    }
                }
                
                oldX = CGFloat(newX)
                oldY = CGFloat(newY!)
            }
        }
    }
    
    // handlers
    func changeScale (byReactingTo pinchRecognizer: UIPinchGestureRecognizer){
        switch pinchRecognizer.state {
        case .changed, .ended:
            scaleConstant *= Double(pinchRecognizer.scale)
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    func changePosition (byReactingTo panRecognizer: UIPanGestureRecognizer){
        switch panRecognizer.state {
        case .changed, .ended:
            translationCoordinate = panRecognizer.translation(in: self)
            panRecognizer.setTranslation(CGPoint.zero, in: self)
    
        default:
            break
        }
    }
    
    func resetTheCenterCoordinate (byReactingTo tapRecognizer: UITapGestureRecognizer) {
        switch tapRecognizer.state {
        case .changed, .ended:
            sumOfTransitions = CGPoint(x: 0.0, y: 0.0)
        default:
            break
        }
    }
}




