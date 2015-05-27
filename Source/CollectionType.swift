//
//  CollectionType.swift
//  FuncySwift
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//
//

import Foundation

/**
Return a LazySequence containing pairs (n, x), where *n*s are consecutive indices of base, and xs are the elements of base.
*/

func xEnumerate<C: CollectionType>(base: C) -> LazySequence<GeneratorOf<(C.Index, C.Generator.Element)>> {
  
  var (inds, vals) = (indices(base).generate(), base.generate())
  
  return lazy(
    GeneratorOf{
      if let val = vals.next(), ind = inds.next() {
        return (ind, val)
      } else {
        return nil
      }
    }
  )
}

/**
Returns the first index where a value satisfies a predicate or nil if one is not found.
*/

func find
  <C : CollectionType>(domain: C, predicate: C.Generator.Element -> Bool) -> C.Index? {
    for (index, value) in xEnumerate(domain) {
      if predicate(value) { return index }
    }
    return nil
}
/**
Returns the indices of elements that satisfy a predicate.
*/

func findMany
  <C : CollectionType>(domain: C, predicate: C.Generator.Element -> Bool)
  -> LazySequence<MapSequenceView<FilterSequenceView<GeneratorOf<(C.Index, C.Generator.Element)>>, C.Index>> {
    
    return xEnumerate(domain).filter{predicate($1)}.map{$0.0}
    
}