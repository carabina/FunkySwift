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
      for _ in 0...1000000 {
        let an = findMany(toSearch, {$0 != "a"})
      }
    }
  }
  func testHis() {
    self.measureBlock() {
      for _ in 0...1000000 {
        let an = findMany(toSearch, {$0 != "a"})
      }
    }
  }
  
}
