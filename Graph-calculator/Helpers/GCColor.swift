//
//  GCColor.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/24/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

struct GCColor {
    
    static func background(forDarkMode darkMode: Bool) -> UIColor {
//        if #available(iOS 13.0, *) {
//            return .systemBackground
//        } else
        if darkMode {
            return .black
        } else {
            return .white
        }
    }
   
    static func previewBackground(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 66, g: 66, b: 66, alpha: 1)
        }
        
        return .white
    }
    
    static func previewOverlay(forDarkMode darkMode: Bool) -> UIColor {
        return UIColor.black.withAlphaComponent(0.25)
    }
    
    static func title(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 237, g: 237, b: 237, alpha: 1)
        }
        
        return self.highlight(forDarkMode: darkMode)
    }
    
    static func subtitle(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return self.alternativeKeyText(forDarkMode: darkMode)
        }
        
        return self.alternativeKey(forDarkMode: darkMode)
    }
    
    static func footnote(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return self.alternativeKey(forDarkMode: darkMode)
        }
        
        return self.key(forDarkMode: darkMode)
    }
    
    static func highlight(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 108, g: 124, b: 126, alpha: 1)
        }
        
        return UIColor(r: 13, g: 62, b: 73, alpha: 1)
    }
    
    static func key(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 66, g: 66, b: 66, alpha: 1)
        }
        
        return UIColor(r: 138, g: 159, b: 162, alpha: 1)
    }
    
    static func alternativeKey(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 90, g: 90, b: 90, alpha: 1)
        }
        
        return UIColor(r: 100, g: 133, b: 140, alpha: 1)
    }
    
    static func keyBorder(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 118, g: 118, b: 118, alpha: 1)
        }
        
        return .white
    }
    
    static func popoverBorder(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 190, g: 190, b: 190, alpha: 1)
        }
        
        return .white
    }
    
    static func alternativeKeyText(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 124, g: 124, b: 124, alpha: 1)
        }
        
        return self.alternativeKey(forDarkMode: darkMode)
    }
}
