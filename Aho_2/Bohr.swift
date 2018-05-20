//
//  Bohr.swift
//  Aho_2
//
//  Created by Marty on 28/04/2018.
//  Copyright © 2018 Marty. All rights reserved.
//

class Bohr {
    let char: Character
    var isComplete = false
    var goodSuffLink: Bohr?
    var suffLink    : Bohr?
    var parent      : Bohr?
    
    var sons            = [Character: Bohr]()
    var nextStateByChar = [Character: Bohr]()
    
    
    init(withChar char: Character) {
        self.char = char
    }
    
    
    func getSuffLink() -> Bohr {
        guard let suffLink = self.suffLink else {
            if self.parent == nil {
                // I'm root
                self.suffLink = self
            } else if self.parent!.parent == nil {
                // I'm son of root
                self.suffLink = self.parent
            } else {
                self.suffLink = self.parent!.getSuffLink().getAutoMoveWithChar(self.char)
            }
            
            return self.suffLink!
        }
        
        return suffLink
    }
    
    func getGoodSuffLink() -> Bohr {
        guard let goodLink = self.goodSuffLink else {
            if self.goodSuffLink == nil {
                let u = self.getSuffLink()
                
                if u.parent == nil {
                    self.goodSuffLink = u
                } else {
                    self.goodSuffLink = u.isComplete ? u : u.getGoodSuffLink()
                }
            }
            return self.goodSuffLink!
        }
        
        return goodLink
    }
    
    func getAutoMoveWithChar(_ char: Character) -> Bohr {
        guard let next = self.nextStateByChar[char] else {
            if let forward = self.sons[char] {
                self.nextStateByChar[char] = forward
                return forward
            } else {
                self.nextStateByChar[char] = self.parent == nil ? self : self.getSuffLink().getAutoMoveWithChar(char)
            }

            return self.nextStateByChar[char]!
        }

        return next
    }
}
