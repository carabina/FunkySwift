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
  Returns the permutations with repetition of a given length of self
  
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
  Returns all the permutations with repetition of self
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
  randomly shuffles self, via the Fisher-Yates shuffle
  */
  
  mutating func shuffle() {
    for i in lazy(1..<self.count).reverse() {
      swap(&self[i], &self[Int(arc4random_uniform(UInt32(i)))])
    }
  }
  
  /**
  returns self randomly shuffled, via the Fisher-Yates shuffle
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
  /**
  returns an array of chunks of self, all of length n. The last chunk may be smaller than n.
  */
  func chunk(n: Int) -> [ArraySlice<T>] {
    return ArraySlice(self).chunk(n)
  }
  
  subscript(r: OpenEndedRange<Int>) -> ArraySlice<T> {
    return self[r.start..<self.count]
  }
  subscript(r: OpenStartedRange<Int>) -> ArraySlice<T> {
    return self[0..<r.end]
  }
}
extension ArraySlice {
  /**
  returns an array of chunks of self, all of length n. The last chunk may be smaller than n.
  */
  func chunk(n: Int) -> [ArraySlice<T>] {
    return self.count <= n ? [self] : [self[0..<n]] + self[n..<self.count].chunk(n)
  }
}


