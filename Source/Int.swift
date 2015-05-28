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
  returns the greatest common divisor of self and a
  */
  func gcd(var a: Int) -> Int {
    var b = self
    while a != 0 { (b, a) = (a, b % a) }
    return b
  }
  /**
  returns the lowest common multiple of self and a
  */
  func lcm(a: Int) -> Int {
    return self * a / self.gcd(a)
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
  
  /**
  repeats a function n times, where n is self
  */
  func times<T>(call: () -> T) { for _ in 0..<self { call() } }
  
  
}

infix operator |+ {associativity left precedence 160}

func |+(lhs: Int, rhs: Int) -> Int {
  
  return lhs.concat(rhs)
  
}