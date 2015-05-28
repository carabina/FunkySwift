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
}