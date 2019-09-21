//
//  AnalyticsManager.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 9/3/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    
    private init() {
        Analytics.setSessionTimeoutInterval(180)
    }
    
    func appearanceMode(_ isDark: Bool) {
        let parameters = ["appearance_isDark": isDark]
        Analytics.logEvent("appearance_mode", parameters: parameters)
    }
    
    func keyPressed(_ keyType: KeyType) {
        guard let keyType = Keypad.keyList[keyType]?.description else {
            return
        }
        
        let parameters = ["key_type": keyType]
        Analytics.logEvent("pressed_key", parameters: parameters)
    }
    
    func switchToAlternativeKeyPressed(_ keyType: KeyType) {
        guard let keyType = Keypad.keyList[keyType]?.description else {
            return
        }
        
        let parameters = ["alt_key_type": keyType]
        Analytics.logEvent("pressed_key", parameters: parameters)
    }
    
    func keySelected(_ keyType: KeyType) {
        guard let keyType = Keypad.keyList[keyType]?.description else {
            return
        }
        
        let parameters = ["key_type": keyType]
        Analytics.logEvent("selected_key", parameters: parameters)
    }
    
    func presentGraphSelected() {
        Analytics.logEvent("graph_presented", parameters: [:])
    }
    
    func operations(_ operations: String) {
        let parameters = ["operation_description": operations]
        Analytics.logEvent("operations", parameters: parameters)
    }
}
