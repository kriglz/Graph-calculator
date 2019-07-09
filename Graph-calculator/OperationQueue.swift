//
//  OperationQueue.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/27/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

class OperationQueue {
    
    var description: String {
        var text = ""
        descriptionQueue.forEach { text.append($0) }
        return text
    }
    
    private var queue: [OperationType] = []
    private var descriptionQueue: [String] = []
    
    func append(_ element: KeyType) {
        guard let operation = Keypad.keyList[element] else {
            return
        }
        
        if let lastOperation = self.queue.last, lastOperation == operation.operationType, !lastOperation.canRepeat {
            self.queue.removeLast()
            self.descriptionQueue.removeLast()
        }
        
        self.queue.append(operation.operationType)
        self.descriptionQueue.append(operation.description)
    }
    
    func append(numeric value: Double) {
        self.queue.append(OperationType.numeric(value))
        self.descriptionQueue.append("\(value)")
    }
}
