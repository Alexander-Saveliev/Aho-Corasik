//
//  Bohr.swift
//  Aho_2
//
//  Created by Marty on 28/04/2018.
//  Copyright © 2018 Marty. All rights reserved.
//

class Bohr {
    init(withChar char: Character) {
        self.char = char
    }
    
    func getSuffLink() -> Bohr {
        if self.suffLink == nil {
            if self.parent == nil {
                // I'm root
                self.suffLink = self
            } else if self.parent!.parent == nil {
                // I'm son of root
                self.suffLink = self.parent
            } else {
                self.suffLink = self.parent!.getSuffLink().getAutoMoveWithChar(self.char)
            }
        }
        
        return self.suffLink!
    }
    
    func getGoodSuffLink() -> Bohr {
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
    
    func getAutoMoveWithChar(_ char: Character) -> Bohr {
        if self.nextStateByChar[char] == nil {
            if let forward = self.sons[char] {
                self.nextStateByChar[char] = forward
            } else {
                if self.parent == nil {
                    self.nextStateByChar[char] = self
                } else {
                    self.nextStateByChar[char] = self.getSuffLink().getAutoMoveWithChar(char)
                }
            }
        }
        
        return self.nextStateByChar[char]!
    }
    
    
    let char: Character
    var isComplete = false
    weak var goodSuffLink: Bohr?
    weak var suffLink    : Bohr?
    weak var parent      : Bohr?
    
    var sons = [Character: Bohr]()
    var nextStateByChar = [Character: Bohr]()
}
