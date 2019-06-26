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
            return UIColor(r: 138, g: 159, b: 162, alpha: 1)
        }
        
        return UIColor(r: 13, g: 62, b: 73, alpha: 1)
    }
    
    static func key(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 76, g: 76, b: 76, alpha: 1)
        }
        
        return UIColor(r: 138, g: 159, b: 162, alpha: 1)
    }
    
    static func alternativeKey(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 110, g: 110, b: 110, alpha: 1)
        }
        
        return UIColor(r: 100, g: 133, b: 140, alpha: 1)
    }
    
    static func keyBorder(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 128, g: 128, b: 128, alpha: 1)
        }
        
        return .white
    }
    
    static func alternativeKeyText(forDarkMode darkMode: Bool) -> UIColor {
        if darkMode {
            return UIColor(r: 144, g: 144, b: 144, alpha: 1)
        }
        
        return self.alternativeKey(forDarkMode: darkMode)
    }
}
