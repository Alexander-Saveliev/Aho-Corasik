//
//  AhoAutomat.swift
//  Aho_2
//
//  Created by Marty on 28/04/2018.
//  Copyright © 2018 Marty. All rights reserved.
//

class AhoAutomat {
    private let root = Bohr(withChar: "\0")
    private var current: Bohr
    
    init() {
        current = root
    }
    
    public func getCurrentStrings() -> [String]? {
        func getStringFromBohr(_ bohr: Bohr) -> String {
            var current = bohr
            var string = ""
            
            while let parent = current.parent {
                string.append(current.char)
                current = parent
            }
            
            return String(string.reversed())
        }
        
        var allStrings = [String]()
        
        if self.current.isComplete {
            allStrings.append(getStringFromBohr(self.current))
        }
        
        var current = self.current.getGoodSuffLink()
        
        while current !== root {
            allStrings.append(getStringFromBohr(current))
            current = current.getGoodSuffLink()
        }
        
        return allStrings.isEmpty ? nil : allStrings
    }
    
    public func addString(_ str: String) {
        guard !str.isEmpty else {
            return
        }
        
        var currentLeaf = root
        
        for char in str {
            if let next = currentLeaf.sons[char] {
                currentLeaf = next
            } else {
                let next = Bohr(withChar: char)
                next.parent = currentLeaf
                
                currentLeaf.sons[char] = next
                currentLeaf = next
            }
        }
        
        currentLeaf.isComplete = true
    }
    
    public func reset() {
        current = root
    }

    
    public func setNextStateByChar(_ char: Character) {
        current = current.getAutoMoveWithChar(char)
    }
    
    
    // MARK: - helpfull things for debug -
    #if DEBUG
    
    public func getCurrentBohr() -> Bohr {
        return current
    }
    
    public func moveForwardByChar(_ char: Character) {
        if let next = current.sons[char] {
            current = next
        }
    }
    
    public func moveBackward() {
        if let previous = current.parent {
            current = previous
        }
    }
    
    #endif
}
