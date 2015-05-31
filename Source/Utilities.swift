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


func filterMap<S: SequenceType, T>(seq: S, map: S.Generator.Element -> T, filter: S.Generator.Element -> Bool) -> GeneratorOf<T> {
  var g = seq.generate()
  return GeneratorOf{ while let e = g.next() { if filter(e) { return map(e) } }; return nil }
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
  var (l, k) = (a.endIndex, a.endIndex.predecessor())
  while a[k] < a[--k] {if k == 0 {return nil}}; while a[--l] <= a[k] {}
  swap(&a[k++], &a[l]); reverse(a[k..<a.endIndex])
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
Returns the first index where a value satisfies a condition or nil if one is not found.
*/
func findLast
  <C: CollectionType where C.Index: BidirectionalIndexType>
  (domain: C, condition: C.Generator.Element -> Bool) -> C.Index? {
    
    for i in lazy(indices(domain)).reverse() { if condition(domain[i]) { return i } }
    
    return nil
}
/**
Returns the last index where value appears in domain or nil if value is not found.
*/

func findLast
  <C: CollectionType where C.Index: BidirectionalIndexType, C.Generator.Element: Equatable>
  (domain: C, value: C.Generator.Element) -> C.Index? {
    
    for i in lazy(indices(domain)).reverse(){ if domain[i] == value { return i }}
    
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
  var accu: [K:[S.Generator.Element]] = [:]
  for el in clos { accu[el.0] = filter(seq, el.1) + (accu[el.0] ?? []) }
  return accu
}

/**
returns a dictionary of which the keys are the elements in seq, and the values are the number of times each element occurs
*/

func histo<S: SequenceType where S.Generator.Element: Hashable>(seq: S) -> [S.Generator.Element:Int] {
  var accu: [S.Generator.Element:Int] = [:]
  for element in seq { accu[element] = accu[element]?.successor() ?? 1 }
  return accu
}
/**
returns a dictionary of which the keys are the keys of clos in seq, and the values are the number of elements that match for each closure in clos
*/
func histoByClosure<K: Hashable, S: SequenceType>(seq: S, clos: [K:(S.Generator.Element -> Bool)]) -> [K : Int] {
  var accu: [K : Int] = [:]
  for el in clos { accu[el.0] = filter(seq, el.1).count + (accu[el.0] ?? 0) }
  return accu
}
/**
returns a generator with all optionals unwrapped, and any that evaluate to nil removed
*/
func skipNil<S: SequenceType, T where S.Generator.Element == T?>(seq: S) -> GeneratorOf<T> {
  var g = seq.generate()
  return GeneratorOf{ while let e = g.next() { if let e = e { return e }}; return nil }
}
/**
simple memoizer
*/
func memoize<T: Hashable, U>(f: (T -> U)) -> (T -> U) {
  
  var prev = [T:U]()
  
  return {
    (arg: T) in
    
    if let ret = prev[arg] { return ret } else {
      
      let ret = f(arg)
      prev[arg] = ret
      return ret
      
    }
  }
}
/**
returns true if outer entirely contains inner
*/
func contains
  <S0: SequenceType,
  S1: SequenceType,
  T: Equatable where
  S0.Generator.Element == T,
  S1.Generator.Element == T>
  (outer: S0, inner: S1) -> Bool {
    var outerGen = outer.generate()
    do { if startsWith(GeneratorSequence(outerGen), inner) { return true }
    } while outerGen.next() != nil
    return false
}

/**
a lazy flatten function that produces a generator
*/
func flatten
  <S: SequenceType where S.Generator.Element: SequenceType>
  (seq: S) -> GeneratorOf<S.Generator.Element.Generator.Element> {
  var g = seq.generate()
  var inG = g.next()?.generate()
  return GeneratorOf{
    while inG != nil {if let next = inG!.next() {return next} else {inG = g.next()?.generate()}}
    return nil
  }
}

/**
replaces every element in seq that corresponds to a key in replacements with the value in replacements
*/

func replace
  <S: SequenceType where S.Generator.Element: Hashable>
  (seq: S, replacements: [S.Generator.Element:S.Generator.Element])
  -> LazySequence<GeneratorOf<S.Generator.Element>> {
    var g = seq.generate()
    return lazy( GeneratorOf { g.next().map{replacements[$0] ?? $0} } )
}

func chunkWithEmpty<S: SequenceType>(seq: S, n: Int) ->  GeneratorOf<[S.Generator.Element]> {
  var (g, count) = (seq.generate(), n + 1)
  var innerGen = GeneratorOf{ count++ == n ? nil : g.next() }
  return GeneratorOf {
    count -= (n + 1)
    return count == 0 ? Array(innerGen) : nil
  }
}
func chunk<S: SequenceType>(seq: S, n: Int) ->  GeneratorOf<[S.Generator.Element]> {
  
  var (g, count) = (seq.generate(), 0)
  var left = true
  
  var innerGen = GeneratorOf<S.Generator.Element>{
    
    if count++ == n {
      return nil
    } else {
      if let n = g.next() {
        return n
      } else {
        left = false
        return nil
      }
    }
  }
  
  return GeneratorOf {
    count = 0
    return left ? Array(innerGen) : nil
  }
}