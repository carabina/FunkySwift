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