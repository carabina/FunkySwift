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
```swift
func combinations(n: Int) -> [[T]]
```
```swift
func permsWithRep(n: Int) -> [[T]]
```
```swift
func perms() -> [[T]]
```
```swift
func perms(n: Int) -> [[T]]
```
```swift
func randomElement() -> T
```
```swift
mutating func shuffle()
```
```swift
func shuffled() -> [T]
```
```swift
mutating func nextLexPerm(isOrderedBefore: (T, T) -> Bool) -> [T]?
```
```swift
mutating func nextLexPerm(isOrderedBefore: (T, T) -> Bool) -> [T]?
```
```swift
func lexPermsOf(isOrderedBefore: (T, T) -> Bool) -> LazySequence<GeneratorOf<[T]>>
```
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