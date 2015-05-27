//
//  FunkySwiftTests.swift
//  FunkySwiftTests
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//  Copyright (c) 2015 Donnacha Oisín Kidney. All rights reserved.
//

import Foundation
import XCTest

let toSearch = "elibaosudhbgaieubry"

let char: Character = "y"

let cond = {$0 == char}




class FunkySwiftTests: XCTestCase {


  func testMine() {
    self.measureBlock() {
      for _ in 0...10000 {
        find(toSearch, cond)
      }
    }
  }
  func testHis() {
    self.measureBlock() {
      for _ in 0...10000 {
        findAS(toSearch, cond)
      }
    }
  }
  
}
