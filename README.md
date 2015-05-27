# FunkySwift

FunkySwift is a library of extensions and tools for Swift. They're a bit functional, but only a bit.

## Contents ##

- [FunkySwift extensions](#extensions)
	- [Array](#array)
	- [LazySequence](#array)
	- [Int](#int)
	- [String](#string)
	- [RangesAndIntervals](#range)

- [Utilities](#utilities)

# Extensions #


## Array ##

###Combinatorics###

####Combinations####

Function  | Description
------------- | -------------
```combinations(n: Int) -> [[T]]```  | Returns an array of the combinations of a given length of self.

```swift
[1, 2, 3].combinations(2) // [[2, 3], [1, 3], [1, 2]]
```

####Permutations####
Function  | Description
------------- | -------------
```permsWithRep(n: Int) -> [[T]]```  | Returns the permutations with repetition of a given length of self
```permsWithRep() -> [[T]]```        | Returns all the permutations with repetition of self
```perms(n: Int) -> [[T]]```  | Returns all the permutations of a given length of self
```perms() -> [[T]]```  | Returns all the permutations of self

These functions return the permutations with and without repetitions of self. Permutations with repetition are generated with ```map()``` nested in ```flatMap()```. Permutations without repetition are generated with a recursive implementation of Heap's algorithm.

```swift
[1, 2].permsWithRep()     // [[1, 1], [1, 2], [2, 1], [2, 2]]
[1, 2, 3].permsWithRep(2) // [[1, 1], [1, 2], [1, 3], [2, 1], [2, 2], [2, 3], [3, 1], [3, 2], [3, 3]]

[1, 2, 3].perms()         // [[1, 2, 3], [2, 1, 3], [3, 1, 2], [1, 3, 2], [2, 3, 1], [3, 2, 1]]
[1, 2, 3].perms(2)        // [[2, 3], [3, 2], [1, 3], [3, 1], [1, 2], [2, 1]]
```


Function  | Description
------------- | -------------
```shuffle()```  | Randomly shuffles self
```shuffled() -> [T]``` | Returns self randomly shuffled

These functions randomly shuffle self, with the Fisher-Yates shuffle algorithm.

```swift
[1, 2, 3].shuffled()  // [2, 3, 1]

var ar = [1, 2, 3]
ar.shuffle()
ar                    // [3, 1, 2]
```

Function  | Description
------------- | -------------
```nextLexPerm(isOrderedBefore: (T, T) -> Bool) -> [T]?```  | Mutates self to the next lexicographical permutation (if it exists), and then returns self (or nil if there is no next permutation)
```lexPermsOf(isOrderedBefore: (T, T) -> Bool) -> LazySequence<GeneratorOf<[T]>>``` | Returns a lazy generator of subsequent lexicographical permutation of self

These functions generate the following permutation of self, according to lexicographical ordering, defined by the closure. [(The algorithm)](https://en.wikipedia.org/wiki/Permutation#Generation_in_lexicographic_order) There is a non-method function (in utilities) that only accepts orderable arrays.

```swift
let ar = [1, 2, 3]
ar.lexPermsOf(<).array  // [[1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]

var mutAr = [1, 2, 3]   // [1, 2, 3]
mutAr.nextLexPerm(<)    // [1, 3, 2]
mutAr                   // [1, 3, 2]
```

####The Rest####

Function  | Description
------------- | -------------
```subscript(r: OpenEndedRange<Int>) -> ArraySlice<T>```  | Returns a slice of self, from an index to the end
```subscript(r: OpenStartedRange<Int>) -> ArraySlice<T>``` | Returns a slice of self, from start to an index

An implementation of open ranges for arrays. 
```swift
let ar = [0, 1, 2, 3, 4]
let split = ar[2..<] // [2, 3, 4]
```
Function  | Description
------------- | -------------
```func randomElement() -> T```| Returns a random element of self


## LazySequence ##
## Int ##
## RangesAndIntervals ##
# Utilities #