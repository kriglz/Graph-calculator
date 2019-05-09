//
//  KeyPadCell.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class KeyPadCell: UICollectionViewCell {
    
    static let identifier = "KeyPadCollectionViewCellIdentifier"
    
    var backgroundMaskView: UIImageView? {
        didSet {
            guard let view = self.backgroundMaskView else {
                return
            }
            
            self.addSubview(view)
            view.mask = self.shapeView
            self.shapeView.frame = self.frame
            
            shapeView.layer.shadowOffset = CGSize(width: 0, height: 1)
            shapeView.layer.shadowOpacity = 0.3
            shapeView.layer.shadowRadius = 1
        }
    }
    
    private let shapeView = UIImageView(image: UIImage(named: "ButtonShape"))
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.03) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }

        // long touch should generate impact also show alternative selections
//        let generator = UIImpactFeedbackGenerator(style: .light)
//        generator.prepare()
//        generator.impactOccurred()
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.07) {
            self.transform = CGAffineTransform.identity
        }
    }
}
