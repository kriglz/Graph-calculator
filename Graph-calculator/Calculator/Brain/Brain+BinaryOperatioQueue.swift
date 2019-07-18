//
//  BinaryOperatioQueue.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/18/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension CalculatorBrain {
    class BinaryOperatioQueue {
        var hasPendingOperations: Bool {
            return !self.queue.isEmpty
        }
        
        private var queue = [BinaryOperation]()
        
        func append(_ operation: BinaryOperation) {
            self.queue.append(operation)
        }
        
        func perform(with value: Double) -> Double? {
            defer {
                self.queue.removeAll()
            }
            
            if queue.isEmpty {
                return nil
            }
            
            if queue.count == 1 {
                return queue[0].perform(with: value)
            }
            
            var newValue = value
            
            while let index = self.queue.firstIndex(where: { $0.priority == .high}) {
                var accumulator = self.queue.count - 1 >= index + 1 ? self.queue[index + 1].firstOperand : value
                accumulator = self.queue[index].perform(with: accumulator)
                
                if self.queue.count - 1 >= index + 1 {
                    self.queue[index + 1].firstOperand = accumulator
                    self.queue.remove(at: index)
                    
                } else if self.queue.count == 1 {
                    return accumulator
                    
                } else {
                    newValue = accumulator
                    self.queue.remove(at: index)
                    break
                }
            }
            
            while self.queue.count > 1 {
                self.queue[1].firstOperand = self.queue[0].perform(with: self.queue[1].firstOperand)
                self.queue.remove(at: 0)
            }
            
            return self.queue[0].perform(with: newValue)
        }
    }
}
