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





class FunkySwiftTests: XCTestCase {


  func testMine() {
    self.measureBlock() {
      for _ in 0...10000 {
        for (index, value) in xEnumerate(toSearch) {
          let an = value
        }
      }
    }
  }
  func testHis() {
    self.measureBlock() {
      for _ in 0...10000 {
        for (index, value) in xEnumerate(toSearch) {
          let an = value
        }
      }
    }
  }
  
}
