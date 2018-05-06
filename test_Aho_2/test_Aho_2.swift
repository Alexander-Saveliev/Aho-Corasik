//
//  test_Aho_2.swift
//  test_Aho_2
//
//  Created by Marty on 28/04/2018.
//  Copyright © 2018 Marty. All rights reserved.
//

import XCTest

class test_Aho_2: XCTestCase {
    
    // MARK: - getting words -
    func testGetEmptyString() {
        let aho = AhoAutomat()
        
        XCTAssertNil(aho.getCurrentStrings())
    }
    
    func testGetSingleLetter() {
        let aho = AhoAutomat()
        aho.addString("a")
        aho.moveForwardByChar("a")
        
        XCTAssertNotNil(aho.getCurrentStrings())
        XCTAssertEqual(aho.getCurrentStrings(), ["a"])
    }
    
    func testGetSingleLetterByLongWord() {
        let aho = AhoAutomat()
        aho.addString("abc")
        aho.moveForwardByChar("a")
        
        XCTAssertNil(aho.getCurrentStrings())
    }
    
    func testGetWordInTheMiddle() {
        let aho = AhoAutomat()
        aho.addString("мыл")
        aho.addString("мама мыла")
        
        XCTAssertNil(aho.getCurrentStrings())
        
        aho.setNextStateByChar("м")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("а")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("м")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("а")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar(" ")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("м")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("ы")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("л")

        XCTAssertEqual(aho.getCurrentStrings(), ["мыл"])
    }
    
    func testGetWordInTheMiddleCrossing() {
        let aho = AhoAutomat()
        aho.addString("ама")
        aho.addString("мама мыла")
        
        aho.setNextStateByChar("м")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("а")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("м")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("а")

        
        XCTAssertEqual(aho.getCurrentStrings(), ["ама"])
    }
    
    func testGetCrossingWord() {
        let aho = AhoAutomat()
        aho.addString("мыф")
        aho.addString("мама мыла")
        
        aho.setNextStateByChar("м")
        aho.setNextStateByChar("а")
        aho.setNextStateByChar("м")
        aho.setNextStateByChar("а")
        aho.setNextStateByChar(" ")
        aho.setNextStateByChar("м")
        aho.setNextStateByChar("ы")
        aho.setNextStateByChar("ф")
        
        print("#####", aho.getCurrentStrings())
        XCTAssertEqual(aho.getCurrentStrings(), ["мыф"])
    }
    
    func testComplexAutomat() {
        let aho = AhoAutomat()
        aho.addString("acab")
        aho.addString("accc")
        aho.addString("acac")
        aho.addString("baca")
        aho.addString("abb")
        aho.addString("z")
        aho.addString("ac")
        
        XCTAssertNil(aho.getCurrentStrings())
        
        aho.moveForwardByChar("a")
        XCTAssertNil(aho.getCurrentStrings())
        
        aho.moveBackward()
        aho.moveForwardByChar("z")
        XCTAssertNotNil(aho.getCurrentStrings())
        XCTAssertEqual(aho.getCurrentStrings(), ["z"])
        
        aho.moveBackward()
        aho.moveForwardByChar("a")
        aho.moveForwardByChar("c")
        XCTAssertNotNil(aho.getCurrentStrings())
        XCTAssertEqual(aho.getCurrentStrings(), ["ac"])
        
        aho.moveBackward()
        aho.moveForwardByChar("c")
        aho.moveForwardByChar("c")
        XCTAssertNil(aho.getCurrentStrings())
        aho.moveForwardByChar("c")
        XCTAssertNotNil(aho.getCurrentStrings())
        XCTAssertEqual(aho.getCurrentStrings(), ["accc"])
    }
    
    // MARK: - Bohr -
    func testEmptyBohr() {
        let bohr = Bohr(withChar: "a")
        
        let suffLink = bohr.getSuffLink()
        
        XCTAssertTrue(bohr === suffLink)
    }
 
    // MARK: - Atuomat -
    func testSmallAutomat() {
        let aho = AhoAutomat()
        
        aho.addString("acc")
        aho.addString("acd")
        aho.addString("ca")
        aho.addString("a")
        
        aho.setNextStateByChar("a")
        XCTAssertEqual(aho.getCurrentStrings(), ["a"])
        
        aho.setNextStateByChar("c")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("a")
        
        XCTAssertEqual(aho.getCurrentStrings(), ["ca", "a"])
        aho.setNextStateByChar("c")
        XCTAssertNil(aho.getCurrentStrings())
        aho.setNextStateByChar("c")
        XCTAssertEqual(aho.getCurrentStrings(), ["acc"])
    }
    
    func testFromTask() {
        let aho = AhoAutomat()
        
        aho.addString("мыл")
        aho.addString("мама мыла")
        
        let strToScane = "мама мыла раму, потом мама мыла дочку, а папа весь день мыл свой мотоцикл."
        
        for char in "мама мы" {
            aho.setNextStateByChar(char)
            XCTAssertNil(aho.getCurrentStrings())
        }
        
        aho.setNextStateByChar("л")
        XCTAssertEqual(aho.getCurrentStrings(), ["мыл"])
        
        aho.setNextStateByChar("а")
        XCTAssertEqual(aho.getCurrentStrings(), ["мама мыла"])
        
        for char in " раму, потом мама мы" {
            aho.setNextStateByChar(char)
            XCTAssertNil(aho.getCurrentStrings())
        }
        
        aho.setNextStateByChar("л")
        XCTAssertEqual(aho.getCurrentStrings(), ["мыл"])
        
        aho.setNextStateByChar("а")
        XCTAssertEqual(aho.getCurrentStrings(), ["мама мыла"])
        
        for char in " дочку, а папа весь день мы" {
            aho.setNextStateByChar(char)
            XCTAssertNil(aho.getCurrentStrings())
        }
        
        aho.setNextStateByChar("л")
        XCTAssertEqual(aho.getCurrentStrings(), ["мыл"])
        
        for char in " свой мотоцикл." {
            aho.setNextStateByChar(char)
            XCTAssertNil(aho.getCurrentStrings())
        }
    }
    
    func testFromTaskModified() {
        let aho = AhoAutomat()
        
        aho.addString("мыл")
        aho.addString("мама мыл")
        
        let strToScane = "мама мыла раму, потом мама мыла дочку, а папа весь день мыл свой мотоцикл."
        
        for char in "мама мы" {
            aho.setNextStateByChar(char)
            XCTAssertNil(aho.getCurrentStrings())
        }
        
        aho.setNextStateByChar("л")
        XCTAssertEqual(aho.getCurrentStrings(), ["мама мыл", "мыл"])
    }
    
    func testSomeComplex() {
        let aho = AhoAutomat()
        
        aho.addString("мыл")
        aho.addString("ыл")
        aho.addString("л")
        aho.addString("мама мыла")
        
        aho.setNextStateByChar("м")
        aho.setNextStateByChar("ы")
        aho.setNextStateByChar("л")
        
        XCTAssertEqual(aho.getCurrentStrings(), ["мыл", "ыл", "л"])
    }
}
