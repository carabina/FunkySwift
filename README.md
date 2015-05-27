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
head | another
------------ | -------------
one | two

```swift
func combinations(n: Int) -> [[T]]
``` | two
Returns the combinations of a given length of self
```swift
func permsWithRep(n: Int) -> [[T]]
```
Returns the permutations with repetition of a given length of self
```swift
func permsWithRep() -> [[T]]
```
Returns all the permutations with repetition of self
```swift
func perms() -> [[T]]
```
Returns all the permutations of self
```swift
func perms(n: Int) -> [[T]]
```
Returns all the permutations of a given length of self
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