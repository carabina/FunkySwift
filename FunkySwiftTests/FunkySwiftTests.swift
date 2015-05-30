//
//  FunkySwiftTests.swift
//  FunkySwiftTests
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//  Copyright (c) 2015 Donnacha Oisín Kidney. All rights reserved.
//

import Foundation
import XCTest
extension Array {
  func perms2() -> [[T]] { return {(var ar) in ar.heaps2(ar.count)}(self) }
  func perms() -> [[T]] { return {(var ar) in ar.heaps(ar.count)}(self) }
  
  private mutating func heaps(n: Int) -> [[T]] {
    return n == 1 ? [self] :
      Swift.reduce(0..<n, [[T]]()) {
        (var shuffles, i) in
        shuffles.extend(self.heaps(n - 1))
        swap(&self[n % 2 == 0 ? i : 0], &self[n - 1])
        return shuffles
    }
  }
  
  private mutating func heaps2(n: Int) -> [[T]] {
    
    if n == 1 {
      return [self]
    } else {
      
      var shuffles: [[T]] = []
      
      for i in 0..<n {
        shuffles.extend(self.heaps2(n - 1))
        swap(&self[n % 2 == 0 ? i : 0], &self[n - 1])
      }
      
      return shuffles
    }
  }
}


let list = ["a", "a", "a", "b", "b"]


class FunkySwiftTests: XCTestCase {

  func testOne() {
    self.measureBlock() {
      for _ in 1...10000{

        let jo = list.perms()
      }

    }
  }
  func testTwo() {
    self.measureBlock() {
      for _ in 1...10000{
        let jo = list.perms2()
      }
      
    }
  }


  
}
