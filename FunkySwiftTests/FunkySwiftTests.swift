//
//  FunkySwiftTests.swift
//  FunkySwiftTests
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//  Copyright (c) 2015 Donnacha Oisín Kidney. All rights reserved.
//

import Foundation
import XCTest
extension LazySequence {
  func dropWhile2(condition: S.Generator.Element -> Bool) -> LazySequence<GeneratorOf<S.Generator.Element>> {
    var g = self.generate()
    var notPassed = true
    return lazy( GeneratorOf{
      while notPassed {
        let next = g.next()
        if (next.map{!condition($0)} ?? true) {
          notPassed = false
          return next
        }
      }
      return g.next()
      }
    )
  }
  func dropWhile1(condition: S.Generator.Element -> Bool) -> LazySequence<GeneratorOf<S.Generator.Element>> {
    var sGen = self.generate()
    var last = sGen.next()
    while last.map(condition) == true { last = sGen.next() }
    var fGen = GeneratorOfOne(last)
    return lazy( GeneratorOf{ fGen.next() ?? sGen.next() } )
  }
}


class FunkySwiftTests: XCTestCase {

  func testOne() {
    self.measureBlock() {
      for _ in 1...1000000{

        let jo = LazySequence([1, 2, 3, 4, 5, 6, 7]).dropWhile1{$0 < 6}.array
      }

    }
  }
  func testTwo() {
    self.measureBlock() {
      for _ in 1...1000000{
        let jo = LazySequence([1, 2, 3, 4, 5, 6, 7]).dropWhile2{$0 < 6}.array
      }
      
    }
  }


  
}
