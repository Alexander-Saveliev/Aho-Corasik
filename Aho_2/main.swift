//
//  main.swift
//  Aho_2
//
//  Created by Marty on 28/04/2018.
//  Copyright © 2018 Marty. All rights reserved.
//

import Foundation

struct SublineElement {
    let position: Int
    let line    : Int
    let word    : String
}


func lineAndPositionByInput(_ input: [String], andElement element: SublineElement) -> SublineElement {
    var line = element.line
    var pos  = element.position - element.word.count + 1
    
    while (pos < 0) {
        line -= 1
        pos += input[line].count + 1
    }
    
    return SublineElement(position: pos, line: line, word: element.word)
}

func printReport(_ foundWords: [SublineElement]) {
    var outLine = ""
    
    for element in foundWords.sorted(by: {$0.line < $1.line || ($0.line == $1.line && $0.position < $1.position)}) {
        //outLine.append("Line \(element.line + 1), position \(element.position + 1): \(element.word)\n")
        outLine.append("\(element.line + 1) \(element.position + 1): \(element.word)\n")
    }
    
    if outLine == "" {
        outLine = "No"
    }
    
    let outputFileName = "output.txt"
    let outputFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/\(outputFileName)")
    
    do {
        try outLine.write(to: outputFileURL, atomically: false, encoding: .utf8)
    }
    catch {
        print(error)
        return
    }
}



// for safe out without throwing
func main() {
    let inputFileName  = "input.txt"
    let inputFileURL  = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/\(inputFileName)")
    
    var input = [String]()

    do {
        input = try String(contentsOf: inputFileURL, encoding: .utf8).components(separatedBy: "\n")
    } catch {
        print("Error: ", error)
        return
    }
    
    let n     = Int(input[0]) ?? 0
    let aho   = AhoAutomat()
    
    for i in stride(from: 1, through: n, by: 1) {
        aho.addString(input[i].lowercased())
    }
    
    let replaceFileName = input[n + 1]
    let replaceFileURL  = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/\(replaceFileName)")
    
    var lines = [String]()
    
    do {
        // простое построчное чтение работает немного медленнее
        lines = try String(contentsOf: replaceFileURL, encoding: .utf8).lowercased().components(separatedBy: "\n")
    } catch {
        print("Error: ", error)
        return
    }
    
    var foundWords   = [SublineElement]()
    
    for (lineNumber, line) in lines.enumerated() {
        for (positionNumber, char) in line.enumerated() {
            aho.setNextStateByChar(char)
            if let found = aho.getCurrentStrings() {
                for foundWord in found {
                    let data = SublineElement(position: positionNumber, line: lineNumber, word: foundWord)
                    foundWords.append(lineAndPositionByInput(lines, andElement: data))
                }
            }
        }
        aho.setNextStateByChar(" ")
    }
    
    printReport(foundWords)
    
}

var sum = 0.0
let startDate = Date()

main()

let endDate = Date()
sum += endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
print(sum)

