//
//  RangesAndIntervals.swift
//  FuncySwift
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//
//

import Foundation

postfix operator ..< { }
prefix operator ..< { }

struct OpenEndedRange<I: ForwardIndexType> { let start: I }


struct OpenStartedRange<I: ForwardIndexType> { let end: I }
/**
A range for one-ended slicing of slicable types, as by `Airspeed Velocity
<http://airspeedvelocity.net/2015/05/02/spelling//>`_.
*/

postfix func ..<<I: ForwardIndexType>(lhs: I) -> OpenEndedRange<I> {
  return OpenEndedRange(start: lhs)
}
/**
A range for one-ended slicing of slicable types, as by `Airspeed Velocity
<http://airspeedvelocity.net/2015/05/02/spelling//>`_.
*/

prefix func ..<<I: ForwardIndexType>(rhs: I) -> OpenStartedRange<I> {
  
  return OpenStartedRange(end: rhs)
}

extension ClosedInterval {
  /**
  Checks if one interval is contained entirely ion the other
  */
  func contains(with: ClosedInterval<T>) -> Bool {
    return self.contains(with.start) && self.contains(with.end)
  }
  /**
  returns the largest interval of which both ends are still inside at least one of the constituent intervals
  */
  func span(with: ClosedInterval) -> ClosedInterval<T> {
    return ClosedInterval(min(self.start, with.start), max(self.end, with.end))
  }
  /**
  returns an interval that is between two other intervals. If the intervals overlap, it will return an interval between the two overlapping ends
  */
  func between(with: ClosedInterval<T>) -> ClosedInterval<T> {
    return {$0 < $1 ? ClosedInterval($0, $1) : ClosedInterval($1, $0)} (max(self.start, with.start), min(self.end, with.end))
  }
  /**
  returns self where no part of self except either the end or start is contained in the interval "with"
  */
  
  func subtract(with: ClosedInterval<T>) -> ClosedInterval<T>? {
    
    switch (with.contains(self.start), with.contains(self.end)) {
      
    case (true, false):
      return ClosedInterval(with.end, self.end)
    case(false, true):
      return ClosedInterval(self.start, with.start)
    case(false, false):
      return self
    default:
      return nil
      
    }
  }
}
func + <T>(l: ClosedInterval<T>, r: ClosedInterval<T>) -> ClosedInterval<T> {
  return l.span(r)
}
func - <T>(l: ClosedInterval<T>, r: ClosedInterval<T>) -> ClosedInterval<T>? {
  return l.subtract(r)
}
