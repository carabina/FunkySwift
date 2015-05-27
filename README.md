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

####Permutations####
Function  | Description
------------- | -------------
```permsWithRep(n: Int) -> [[T]]```  | Returns the permutations with repetition of a given length of self
```permsWithRep() -> [[T]]```        | Returns all the permutations with repetition of self
```perms(n: Int) -> [[T]]```  | Returns all the permutations of a given length of self
```perms() -> [[T]]```  | Returns all the permutations of self

These functions return the permutations with and without repetitions of self. Permutations with repetition are achieved with ```map()``` nested in ```flatMap()```. Permutations without repetition are generated with a recursive implementation of Heap's algorithm.

```swift
func randomElement() -> T
```
Returns a random element of self
```swift
mutating func shuffle()
```
randomly shuffles self, via the Fisher-Yates shuffle
```swift
func shuffled() -> [T]
```
returns self randomly shuffled, via the Fisher-Yates shuffle
```swift
mutating func nextLexPerm(isOrderedBefore: (T, T) -> Bool) -> [T]?
```
Returns the next permutation of self in lexicographical order according to the closure isOrderedBefore
```swift
func lexPermsOf(isOrderedBefore: (T, T) -> Bool) -> LazySequence<GeneratorOf<[T]>>
```
Returns a lazy generator of permutations of self in lexicographical order according to the closure isOrderedBefore
```swift
subscript(r: OpenEndedRange<Int>) -> ArraySlice<T>
```
```swift
subscript(r: OpenStartedRange<Int>) -> ArraySlice<T>
```
## LazySequence ##
## Int ##
## RangesAndIntervals ##
# Utilities #