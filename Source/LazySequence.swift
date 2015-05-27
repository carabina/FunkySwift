//
//  LazySequence.swift
//  FuncySwift
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//
//

import Foundation

extension LazySequence {
  
  /**
  First element of the sequence.
  
  :returns: First element of the sequence if present
  */
  
  func first()-> S.Generator.Element? {
    var g = self.generate()
    return g.next()
  }
  
  /**
  The first n elements of the sequence
  
  :param: n The length of the sequence to return. If n >= self.count, the entire sequence will be returned.
  :returns: LazySequence of elements
  */
  
  func take(n: Int) -> LazySequence<GeneratorOf<S.Generator.Element>> {
    var (g, count) = (self.generate(), 0)
    return lazy( GeneratorOf{ ++count > n ? nil : g.next() })
  }
  
  /**
  elements of the sequence until the condition returns false.
  
  :param: condition The condition at which to stop the sequence.
  :returns: a LazySequence of elements, where the last element is the last to return true for the condition.
  */
  
  func takeWhile(condition: S.Generator.Element -> Bool)
    -> LazySequence<GeneratorOf<S.Generator.Element>> {
      var g = self.generate()
      return lazy( GeneratorOf{ g.next().flatMap{ condition($0) ? $0 : nil }})
  }
  
  /**
  elements of the sequence after the first element that returns true for a condition.
  
  :param: condition The condition at which to start the sequence.
  :returns: a LazySequence of elements, where the first element is the element immediately after the first element to satisfy the condition in the underlying sequence.
  */
  
  func takeAfter(condition: S.Generator.Element -> Bool)
    -> LazySequence<SequenceOf<S.Generator.Element>> {
      var g = self.generate()
      while (g.next().map(condition) == false) {}
      return lazy( SequenceOf { g } )
  }
  
  /**
  elements after the first n elements in a sequence
  
  :param: n Number of elements to drop
  :returns: a LazySequence from n to the end
  */
  
  func drop(n: Int) -> LazySequence<SequenceOf<S.Generator.Element>> {
    var g = self.generate()
    for _ in 0..<n { g.next() }
    return lazy( SequenceOf { g } )
  }
  
  /**
  A sequence with the first elements that return true for the condition dropped.
  
  :param: condition The condition with which to drop elements.
  :returns: a LazySequence of elements, where the first element is the first to return false for the condition.
  */
  
  func dropWhile(condition: S.Generator.Element -> Bool) -> LazySequence<GeneratorOf<S.Generator.Element>> {
    var sGen = self.generate()
    var last = sGen.next()
    while last.map(condition) == true { last = sGen.next() }
    var fGen = GeneratorOfOne(last)
    return lazy( GeneratorOf{ fGen.next() ?? sGen.next() } )
  }
  
  /**
  elements after the first element in a sequence
  
  :returns: a LazySequence of all but the first element of self
  */
  
  func dropFirst() -> LazySequence<SequenceOf<S.Generator.Element>> {
    var g = self.generate(); g.next()
    return lazy( SequenceOf { g } )
  }
  
  /**
  Return elements before the last element in self (very very slowly)
  
  :returns: a LazySequence of all but the last element of self
  */
  
  func dropLast() -> LazySequence<GeneratorOf<S.Generator.Element>> {
    var gen = self.generate()
    if var prev = gen.next() {
      return lazy( GeneratorOf{ gen.next().map{ (var next) in swap(&prev, &next); return next }})
    } else {
      return lazy( GeneratorOf{ nil })
    }
  }
  
  /**
  Return the result of repeatedly calling combine with an accumulated value initialized to initial and each element of sequence, in turn.
  */
  
  func reduce<U>(initial: U, combine: (U, S.Generator.Element) -> U) -> U {
    return Swift.reduce(self, initial, combine)
  }
  
  /**
  Return the result of repeatedly calling combine with an accumulated value initialized to initial and each element of sequence, in turn. The initial value is taken to be the first element of the sequence.
  */
  
  func reduce(combine: (S.Generator.Element, S.Generator.Element) -> S.Generator.Element) -> S.Generator.Element? {
    return self.first().map{ Swift.reduce(self.dropFirst(), $0, combine) }
  }
  
  /**
  Similar to the reduce() function, but produces a LazySequence of successive accumulating values
  
  :param: initial The initial value
  :param: combine a closure which takes two arguments: successive elements of the underlying sequence, and whatever it previously returned (or the initial value, for the first element in the sequence)
  :returns: a LazySequence of whatever the combine closure returns
  */
  
  func scan<U>(initial: U, combine: (U, S.Generator.Element) -> U) -> LazySequence<GeneratorOf<U>> {
    var (prev, g) = (initial, self.generate())
    return lazy( GeneratorOf{ g.next().map { prev = combine(prev, $0); return prev } } )
  }
  
  /**
  Similar to the reduce() function, but produces a LazySequence of successive accumulating values, where the initial value is taken to be the first value in the sequence
  
  :param: combine a closure which combines the first element in the list with the second, and then subsequently combines each element in the list with whatever it returned last
  :returns: a LazySequence of whatever the combine closure returns
  */
  
  func scan(combine: (S.Generator.Element, S.Generator.Element) -> S.Generator.Element) -> LazySequence<GeneratorOf<S.Generator.Element>> {
    var g = self.generate()
    if var prev = g.next() {
      return lazy( GeneratorOf{ g.next().map { prev = combine(prev, $0); return prev } } )
    } else {
      return lazy( GeneratorOf{nil} )
    }
  }
  
  /**
  Returns a LazySequence of self without repetitions, according to the isEqual closure. (the non-method function is much faster)
  
  :param: isEqual takes two arguments, should return true if they are equivalent, or false if they are not
  :returns: a LazySequence of unique elements
  */
  
  func uniques
    (isEqual: (S.Generator.Element, S.Generator.Element) -> Bool)
    -> LazySequence<FilterSequenceView<S>> {
      
      var prevs: [S.Generator.Element] = []
      
      return self.filter{
        element in
        if !contains(prevs, {isEqual($0, element)}) {
          prevs.append(element)
          return true
        } else {
          return false
        }
      }
  }
  
  /**
  an endless repetition of self
  */
  
  func cycle() -> LazySequence<GeneratorOf<S.Generator.Element>> {
    var g = self.generate()
    return lazy( GeneratorOf{
      if let next = g.next() {
        return next
      } else {
        g = self.generate()
        return g.next()
      }
      } )
  }
  
  /**
  Constructs a sequence with a new sequence at the beginning
  
  :param: with The sequence to add to the beginning
  :returns: a LazySequence of the sequence given, followed by self
  */
  
  func cons
    <T : SequenceType where T.Generator.Element == S.Generator.Element>
    (with: T) -> LazySequence<GeneratorOf<S.Generator.Element>> {
      var (fGen, sGen) = (with.generate(), self.generate())
      return lazy( GeneratorOf{ fGen.next() ?? sGen.next() })
  }
  
  /**
  Constructs a sequence with a new sequence at the end
  
  :param: with The sequence to add to the end
  :returns: a LazySequence of self, followed by the sequence given.
  */
  
  func extend
    <T : SequenceType where T.Generator.Element == S.Generator.Element>(with: T)
    -> LazySequence<GeneratorOf<S.Generator.Element>> {
      var (fGen, sGen) = (self.generate(), with.generate())
      return lazy( GeneratorOf{ fGen.next() ?? sGen.next() })
  }
  
  /**
  Constructs a sequence with a new element at the beginning
  
  :param: with The sequence to add to the beginning
  :returns: a LazySequence of the element given, followed by self
  */
  
  func cons(element: S.Generator.Element) -> LazySequence<GeneratorOf<S.Generator.Element>>  {
    var (fGen, sGen) = (GeneratorOfOne(element), self.generate())
    return lazy( GeneratorOf{ fGen.next() ?? sGen.next() })
  }
  
  /**
  Constructs a sequence with a new element at the end
  
  :param: element The element to add to the end
  :returns: a LazySequence of self, followed by the element given
  */
  
  func append(element: S.Generator.Element) -> LazySequence<GeneratorOf<S.Generator.Element>>  {
    var (fGen, sGen) = (self.generate(), GeneratorOfOne(element))
    return lazy( GeneratorOf{ fGen.next() ?? sGen.next() })
  }
  
}

