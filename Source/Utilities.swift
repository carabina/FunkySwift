//
//  Utilities.swift
//  FunkySwift
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//  Copyright (c) 2015 Donnacha Oisín Kidney. All rights reserved.
//

import Foundation

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

/**
Return a LazySequence containing pairs (n, x), where *n*s are consecutive indices of base, and xs are the elements of base.
*/

func xEnumerate<C: CollectionType>(base: C) -> LazySequence<Zip2<Range<C.Index>, C>> {
  
  return lazy(zip(indices(base), base))
  
}
/**
Returns the first index where a value satisfies a predicate or nil if one is not found.
*/

func find
  <C : CollectionType>(domain: C, predicate: C.Generator.Element -> Bool) -> C.Index? {
    for i in indices(domain) { if predicate(domain[i]) { return i } }
    return nil
}
/**
Returns the indices of elements that satisfy the include closure.
*/

func findMany
  <C : CollectionType>(domain: C, include: C.Generator.Element -> Bool)
  -> LazySequence<FilterSequenceView<Range<C.Index>>>{
    
    return lazy(indices(domain)).filter{include(domain[$0])}
    
}

/**
Returns the indices of elements that match the element.

:param: element an element to match to elements in the domain
:param: domain the CollectionType to be searched
*/

func findMany
  <C : CollectionType where C.Generator.Element : Equatable>(domain: C, element: C.Generator.Element)
  -> LazySequence<FilterSequenceView<Range<C.Index>>>{
    
    return lazy(indices(domain)).filter{domain[$0] == element}
    
}
/**
Categorises elements of a sequence according to closures.

:param: seq The sequence to catagorise
:param: clos A dictionary of keys and closures.

:returns: A dictionary, where the keys are the keys of the clos argument, and the values are whatever values in seq that the corresponding closure matched for
*/

func catByClosure<K: Hashable, S: SequenceType>(seq: S, clos: [K:(S.Generator.Element -> Bool)]) -> [K : [S.Generator.Element]] {
  
  let empty: [K:[S.Generator.Element]] = [:]
  
  return reduce(clos, empty) {
    (var accu, el) in
    accu[el.0] = filter(seq, el.1) + (accu[el.0] ?? [])
    return accu
  }
}

