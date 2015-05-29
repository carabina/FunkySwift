//
//  FunkySwiftTests.swift
//  FunkySwiftTests
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//  Copyright (c) 2015 Donnacha Oisín Kidney. All rights reserved.
//

import Foundation
import XCTest
func skipNil2<S: SequenceType, T where S.Generator.Element == T?>(seq: S) -> GeneratorOf<T> {
  var g = seq.generate()
  return GeneratorOf{
    for;;{
      if let e = g.next(){
        if let e = e { return e }
      } else {
        return nil
      }
    }
  }
}
func skipNil3<S: SequenceType, T where S.Generator.Element == T?>(seq: S) -> GeneratorOf<T> {
  var g = seq.generate()
  return GeneratorOf{ while let e = g.next() { if let e = e { return e }}; return nil }
}
let jo: [Int?] = [1, nil, 2, nil, 3, nil, 4, nil, 5, nil, 6]
class FunkySwiftTests: XCTestCase {

  func testOne() {
    self.measureBlock() {
      for _ in 1...10000{

        for i in lazy(jo).filter({$0 != nil}).map({$0!}) {
          let jojo = i
        }
      }

    }
  }
  func testTwo() {
    self.measureBlock() {
      for _ in 1...10000{
        for i in skipNil(jo) {
          let jojo = i
        }
      }
      
    }
  }
  func testThree() {
    self.measureBlock() {
      for _ in 1...10000{
        for i in skipNil2(jo) {
          let jojo = i
        }
      }
      
    }
  }

  
}
