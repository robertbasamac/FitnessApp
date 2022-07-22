//
//  Queue.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.07.2022.
//

import Foundation

struct Queue<T> {
    private var elements: [T] = []
    
    //MARK: - Add new element in front or back of the queue
    mutating func push_front(_ value: T) {
        elements.append(value)
    }
    
    mutating func push_back(_ value: T) {
        elements.insert(value, at: 0)
    }
    
    //MARK: - Remove first or last element and return it
    mutating func pop_back() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        
        return elements.removeFirst()
    }
    
    mutating func pop_front() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        
        return elements.removeLast()
    }
    
    //MARK: - Return first or last element
    var front: T? {
        return elements.first
    }
    
    var back: T? {
        return elements.last
    }
}
