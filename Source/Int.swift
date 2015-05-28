//
//  Int.swift
//  FunkySwift
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//  Copyright (c) 2015 Donnacha Oisín Kidney. All rights reserved.
//

import Foundation

extension Int {
  func isEven() -> Bool {
    return self % 2 == 0
  }
  func isOdd() -> Bool {
    return self % 2 != 0
  }
  /**
  mutates self to be the greatest common divisor of self and x
  */
  mutating func gcd(var x: Int) {
    while x != 0 { (self, x) = (x, self % x) }
  }
  
  /**
  concatenates self with x, as in: 54.concat(21) = 5421
  
  :param: the number to be concatenated onto the end of self
  */
  
  func concat(x: Int) -> Int {
    return self * Int(pow(10,(ceil(log10(Double(x)))))) + x
  }
  
  /**
  returns an array of the digits of self
  */
  
  func digits() -> [Int] {
    var left = self
    return Array(
      GeneratorOf<Int> {
        let ret = left % 10
        left /= 10
        return ret > 1 ? ret : nil
      }
    ).reverse()
  }
  
}

infix operator |+ {associativity left precedence 160}

func |+(lhs: Int, rhs: Int) -> Int {
  
  return lhs.concat(rhs)
  
}