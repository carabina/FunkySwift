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
  
  func primesBelow() -> GeneratorOf<Int> {
    let max = Int(ceil(sqrt(Double(self))))
    var (nums, i) = ([Int](0..<self), 1)
    return GeneratorOf {
      for (++i; i < self; ++i) { if nums[i] != 0 {
        if i < max {for nP in stride(from: i*i, to: self, by: i){nums[nP] = 0}}
        return i
      }}
      return nil
    }
  }
  
  func primeFactors() -> GeneratorOf<Int> {
    var g = self.primesBelow()
    var accu = 1
    return GeneratorOf{
      while let next = g.next() where accu != self {
        if self % next == 0{
          for(var tot = accu; self % tot == 0; tot *= next) {accu = tot}
          return next
        }
      }
      return nil
    }
  }
  
  func isPrime() -> Bool {
    switch self {
    case let n where n < 2:
      return false
    case 2, 3:
      return true
    default:
      let max = Int(sqrt(Double(self)))
      var nums = [Int](0...self)
      for (var i = 2; i <= max; ++i) { if nums[i] != 0 {
        if self % i == 0 { return false } else {
          for nP in stride(from: i*i, through: max, by: i){ nums[nP] = 0 }
        }
      }}
      return true
    }
  }
  
  func isDivBy(n: Int) -> Bool {
    return self % n == 0
  }
  
  
}

infix operator |+ {associativity left precedence 160}

func |+(lhs: Int, rhs: Int) -> Int {
  
  return lhs.concat(rhs)
  
}

func remquo(x: Int, y: Int) -> (Int, Int) {
  
  let ans = div(Int32(x), Int32(y))
  
  return (Int(ans.rem), Int(ans.quot))
  
}