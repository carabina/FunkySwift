//
//  Array.swift
//  FuncySwift
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//
//

import Foundation

internal extension Array {
  
  /**
  Returns the combinations of a given length of self
  
  :param: n length of the combinations
  :returns: an array of combinations
  */
  
  func combinations(n: Int) -> [[T]] {
    
    var (objects, combos) = (self, [[T]]())
    if n == 0 { combos = [[]] } else {
      while !objects.isEmpty {
        let element = objects.removeLast()
        combos.extend(objects.combinations(n - 1).map{ $0 + [element] })
      }
    }
    return combos
  }
  
  /**
  Returns the permutations with repitition of a given length of self
  
  :param: n length of the permutations
  :returns: an array of permutations
  */
  func permsWithRep(n: Int) -> [[T]] {
    return Swift.reduce(1..<n, self.map{[$0]}) {
      prevPerms, _ in
      prevPerms.flatMap{
        prevPerm in self.map{ prevPerm + [$0] }
      }
    }
  }
  
  /**
  Returns all the permutations with repitition of self
  */
  
  func permsWithRep() -> [[T]] { return permsWithRep(self.count) }
  
  /**
  Returns all the permutations of self
  */
  
  func perms() -> [[T]] { return {(var ar) in ar.heaps(ar.count)}(self) }
  
  /**
  Heap's algorithm
  */
  
  private mutating func heaps(n: Int) -> [[T]] {
    return n == 1 ? [self] :
      Swift.reduce(0..<n, [[T]]()) {
        (var shuffles, i) in
        shuffles.extend(self.heaps(n - 1))
        swap(&self[n % 2 == 0 ? i : 0], &self[n - 1])
        return shuffles
    }
  }
  
  /**
  Returns all the permutations of a given length of self
  
  :param: n length of the permutations
  */
  
  func perms(n: Int) -> [[T]] {
    return self.combinations(n).flatMap{$0.perms()}
  }
  
  /**
  Returns a random element of self
  */
  func randomElement() -> T {
    return self[Int(arc4random_uniform(UInt32(self.count)))]
  }
  
  /**
  randomly shuffles self, via the fisher-yates shuffle
  */
  
  mutating func shuffle() {
    for i in lazy(1..<self.count).reverse() {
      swap(&self[i], &self[Int(arc4random_uniform(UInt32(i)))])
    }
  }
  
  /**
  returns self randomly shuffled, via the fisher-yates shuffle
  */
  
  func shuffled() -> [T] {
    var ar = self
    ar.shuffle()
    return ar
  }
  /**
  Returns the next permutation of self in lexicographical order according to the closure isOrderedBefore
  
  :param: isOrderedBefore a closure that returns true if its first argument is ordered before its second
  */
  mutating func nextLexPerm(isOrderedBefore: (T, T) -> Bool) -> [T]? {
    var gen = lazy(self).reverse().generate()
    var (l, k) = (self.endIndex, self.endIndex.predecessor().predecessor())
    var (prev, cur) = (gen.next(), gen.next())
    for (;
      (cur.flatMap{cur in prev.map{!isOrderedBefore(cur, $0)}} ?? false);
      swap(&prev, &cur), cur = gen.next()) {
        k = k.predecessor()
    }
    if k < self.startIndex {return nil}
    gen = lazy(self).reverse().generate()
    do {l = l.predecessor()} while (gen.next().map{!isOrderedBefore(cur!, $0)} ?? false)
    swap(&self[k], &self[l])
    self[k+1..<self.count] = self[k+1..<self.count].reverse()
    return self
  }
  /**
  Returns a lazy generator of permutations of self in lexicographical order according to the closure isOrderedBefore
  
  :param: isOrderedBefore a closure that returns true if its first argument is ordered before its second
  :returns: a LazySequence of arrays
  */
  func lexPermsOf(isOrderedBefore: (T, T) -> Bool) -> LazySequence<GeneratorOf<[T]>> {
    var a = self
    return lazy( GeneratorOf{ a.nextLexPerm(isOrderedBefore) })
  }
  subscript(r: OpenEndedRange<Int>) -> ArraySlice<T> {
    return self[r.start..<self.count]
  }
  subscript(r: OpenStartedRange<Int>) -> ArraySlice<T> {
    return self[0..<r.end]
  }
}

/**
Returns a LazySequence of a sequence without repititions, (much faster than the method on LazySequence, seeing as it uses Sets)

:param: seq a sequence of Hashable elements
:returns: a LazySequence of unique elements
*/

func uniques
  <S: SequenceType where S.Generator.Element: Hashable>
  (seq: S) -> LazySequence<FilterSequenceView<S>> {
    
    var prevs = Set<S.Generator.Element>()
    
    return lazy(seq).filter{
      if !prevs.contains($0) {
        prevs.insert($0)
        return true
      } else {
        return false
      }
    }
}

/**
Checks if all elements in seq satisfy the condition

:param: seq the sequence to be checked
:param: condition a closure that takes elements from the sequence and returns a Bool
:returns: true iff all elements in self satisfy the condition
*/
func all<S: SequenceType>(seq: S, condition: S.Generator.Element -> Bool) -> Bool { return !contains(seq) {!condition($0)} }

/**
Returns the next permutation of an array in lexicographical order

:param: a the orderable array of elements to permute
*/
func nextLexPerm<T: Comparable>(inout a: [T]) -> [T]? {
  
  var gen = lazy(a).reverse().generate()
  var (l, k) = (a.endIndex, a.endIndex.predecessor().predecessor())
  var (prev, cur) = (gen.next(), gen.next())
  for (;cur >= prev; swap(&prev, &cur), cur = gen.next()) {k = k.predecessor()}
  if k < a.startIndex {return nil}
  gen = lazy(a).reverse().generate()
  do {l = l.predecessor()} while gen.next() <= cur
  swap(&a[k], &a[l])
  reverse(a[k+1..<a.count])
  return a
  
}

/**
Returns a Generator of permutations of a, in lexicographical order

:param: a the orderable array of elements to permute
*/

func lexPermsOf<T: Comparable>(var a: [T]) -> LazySequence<GeneratorOf<[T]>> {
  return lazy( GeneratorOf{ nextLexPerm(&a) })
}


