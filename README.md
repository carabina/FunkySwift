# FunkySwift

FunkySwift is a library of extensions and functional(ish) tools for Swift.

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
`combosWithRep(n: Int) -> [[T]]` | Returns the combinations with repetition of a given length of self.

```swift
[1, 2, 3].combinations(2)  // [[2, 3], [1, 3], [1, 2]]
[1, 2, 3].combosWithRep(2) // [[3, 3], [2, 3], [1, 3], [2, 2], [1, 2], [1, 1]]
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

These functions generate the following permutation of self, according to lexicographical ordering, defined by the closure. [(The algorithm)](https://en.wikipedia.org/wiki/Permutation#Generation_in_lexicographic_order) There is a non-method function (in utilities) that only accepts order-able arrays.

```swift
let ar = [1, 2, 3]
ar.lexPermsOf(<).array  // [[1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]

var mutAr = [1, 2, 3]   // [1, 2, 3]
mutAr.nextLexPerm(<)    // [1, 3, 2]
mutAr                   // [1, 3, 2]
```
Function  | Description
------------- | -------------
`everyOf<S: SequenceType where S.Generator.Element == T>(ar: S...) -> [[T]]` | returns an array of arrays, each array containing one element from every array, in every possible combination

```swift
[1, 2, 3].everyOf([1, 2]) // [[1, 1], [1, 2], [2, 1], [2, 2], [3, 1], [3, 2]]
[1, 2].everyOf([3, 4], [5, 6]) // [[1, 3, 5], [1, 3, 6], [1, 4, 5], [1, 4, 6], [2, 3, 5], [2, 3, 6], [2, 4, 5], [2, 4, 6]]
```

####The Rest####

Function  | Description
------------- | -------------
```subscript(r: OpenEndedRange<Int>) -> ArraySlice<T>```  | Returns a slice of self, from an index to the end
```subscript(r: OpenStartedRange<Int>) -> ArraySlice<T>``` | Returns a slice of self, from start to an index

An implementation of open ranges for arrays, as by [Airspeed Velocity](http://airspeedvelocity.net/2015/05/02/spelling//).
```swift
let ar = [0, 1, 2, 3, 4]
let split = ar[2..<] 		// [2, 3, 4]
```
Function  | Description
------------- | -------------
```func randomElement() -> T```| Returns a random element of self

Function  | Description
------------- | -------------
`chunk(n: Int) -> [ArraySlice<T>]` | returns an array of chunks of self, all of length n. The last chunk may be smaller than n.
`cycle() -> GeneratorOf<T> ` | an endless repetition of self
`interpose(with: S.Generator.Element) -> GeneratorOf<S.Generator.Element>` | returns a generator of the elements of self with "with" inserted between every element

```swift
[1, 2, 3, 4, 5].chunk(2) 	// [[1, 2], [3, 4], [5]]
for i in [1, 2, 3].cycle() { 
  print(i)			// 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3...
}
Array([1, 2, 3, 4, 5].interpose(6)) // [1, 6, 2, 6, 3, 6, 4, 6, 5, 6]

```

## LazySequence ##

### Lazy Slicing ###

Function  | Description
------------- | -------------
`takeFirst() -> S.Generator.Element?` | Returns the first element of the sequence (if it is present)
`take(n: Int) -> LazySequence<GeneratorOf<S.Generator.Element>>` | The first n elements of the sequence

This function returns the first elements of a lazy sequence, without evaluating the whole sequence. If n is larger than the sequence being taken from, the entire sequence will be returned.

```swift
var i = 0
let endless = lazy(GeneratorOf{++i})            // 1, 2, 3, 4, 5, 6, 7, 8, 9...
endless.takeFirst()                           	// 1 (optional)
i = 0
endless.take(3).array                         	// [1, 2, 3]
```

Function  | Description
------------- | -------------
`dropFirst() -> LazySequence<SequenceOf<S.Generator.Element>>` | elements after the first element in a sequence
`drop(n: Int) -> LazySequence<SequenceOf<S.Generator.Element>>` | elements after the first n elements in a sequence

These drop a given number of elements from a lazy sequence. Although the sequences are still evaluated lazily, the dropped elements all must be stepped through, so the complexity is O(*n*) where *n* is the number of elements dropped.

```swift
let nums = LazySequence([1, 2, 3, 4, 5])
nums.drop(3).array                       // [4, 5]
```

Function  | Description
------------- | -------------
`dropLast() -> LazySequence<GeneratorOf<S.Generator.Element>>` | Return elements before the last element in self (very very slowly)

This is slow. Don't do this (ya numpty). If you start to do this, it's `.array` time.

### Conditional Lazy Slicing ###

Function  | Description
------------- | -------------
`takeWhile(condition: S.Generator.Element -> Bool) -> LazySequence<GeneratorOf<S.Generator.Element>>` | elements of the sequence until the condition returns false.
`dropWhile(condition: S.Generator.Element -> Bool) -> LazySequence<GeneratorOf<S.Generator.Element>>` | A sequence with the first elements that return true for the condition dropped.
`takeAfter(condition: S.Generator.Element -> Bool) -> LazySequence<SequenceOf<S.Generator.Element>>` | elements of the sequence after the first element that returns true for a condition.

These functions drop and take from sequences on the basis of a condition. `takeWhile()` takes all of the elements up to and not including an element that returns false for the condition. `dropWhile()` continuously drops elements until an element returns false for the condition. `takeAfter()` walks along the sequence, and once it finds an element that returns true for its closure, it returns the elements after it.

```swift
let nums = LazySequence([1, 2, 3, 4, 5, 6, 7, 8, 9])

nums.takeWhile{$0 < 5}.array	// [1, 2, 3, 4]
nums.dropWhile{$0 < 5}.array	// [5, 6, 7, 8, 9]
nums.takeAfter{$0 >= 5}.array	// [6, 7, 8, 9]
```
### Hopping, Skipping, and Jumping###
Function  | Description
------------- | -------------
`jump(n: Int) -> LazySequence<GeneratorOf<S.Generator.Element>>` | returns a sequence made by jumping over n elements of the underlying sequence. The first element of the underlying sequence is jumped over.
`hop(n: Int) -> LazySequence<GeneratorOf<S.Generator.Element>>` | returns a sequence made by hopping over n elements of the underlying sequence. The first element of the underlying sequence is not hopped over.

```swift
let seq = LazySequence([1, 2, 3, 4, 5, 6])

seq.hop(2).array  // [1, 4]
seq.jump(2).array // [3, 6]
```

### Higher-Order ###

Function  | Description
------------- | -------------
`reduce<U>(initial: U, combine: (U, S.Generator.Element) -> U) -> U` | Return the result of repeatedly calling combine with an accumulated value initialised to initial and each element of sequence, in turn.
`reduce(combine: (S.Generator.Element, S.Generator.Element) -> S.Generator.Element) -> S.Generator.Element?` | Same as above, except the initial value is taken to be the first element of the sequence.

The first function is just the same as the standard library `reduce()`, whereas the second doesn't require an initial value: it uses the first value of the sequence.

```swift
let nums = LazySequence([1, 2, 3, 4, 5])
nums.reduce(+) // 15
```
Function  | Description
------------- | -------------
`scan<U>(initial: U, combine: (U, S.Generator.Element) -> U) -> LazySequence<GeneratorOf<U>>` | Similar to the reduce() function, but produces a LazySequence of successive accumulating values
`scan(combine: (S.Generator.Element, S.Generator.Element) -> S.Generator.Element) -> LazySequence<GeneratorOf<S.Generator.Element>>` | Same as above, but the initial value is taken to be the first value in the sequence

These functions are similar to `reduce()`. They repeatedly apply a `combine()` closure to an accumulator. Differently, though, they return a sequence of each successive accumulator. Again, similar to `reduce()`, the version without an initial value takes the first element of the sequence as the initial value. They can be evaluated lazily, and therefore used with endless lists.

```swift
let nums = LazySequence([1, 2, 3, 4, 5])
nums.scan(0, combine: +).array          	// [1, 3, 6, 10, 15]
nums.scan(+).array                      	// [3, 6, 10, 15]

var i = 0
let endlessNums = lazy(GeneratorOf{++i})	// 1, 2, 3, 4, 5, 6, 7, 8, 9...
nums.scan(0, combine: +).take(5).array 		// [1, 3, 6, 10, 15]
nums.scan(+).take(5).array                  // [3, 6, 10, 15]
```
### Making Sequences ###
Function  | Description
------------- | -------------
`cycle() -> LazySequence<GeneratorOf<S.Generator.Element>>` | an endless repetition of self

cycles a sequence (self) endlessly. 

```swift
LazySequence([1, 2, 3]).cycle() // 1, 2, 3, 1, 2, 3, 1, 2, 3...
```
Function  | Description
------------- | -------------
`cons<T : SequenceType where T.Generator.Element == S.Generator.Element> (with: T) -> LazySequence<GeneratorOf<S.Generator.Element>>` | Constructs a sequence with a new sequence at the beginning
`extend<T : SequenceType where T.Generator.Element == S.Generator.Element>(with: T) -> LazySequence<GeneratorOf<S.Generator.Element>>` | Constructs a sequence with a new sequence at the end
`cons(element: S.Generator.Element) -> LazySequence<GeneratorOf<S.Generator.Element>>` | Constructs a sequence with a new element at the beginning
`append(element: S.Generator.Element) -> LazySequence<GeneratorOf<S.Generator.Element>>` | Constructs a sequence with a new element at the end

These are not fast. Sequences in Swift aren't lists: these aren't really `cons()` functions.

Function  | Description
------------- | -------------
`uniques (isEqual: (S.Generator.Element, S.Generator.Element) -> Bool) -> LazySequence<FilterSequenceView<S>>` | Returns a LazySequence of self without repetitions, according to the isEqual closure. (the non-method function is much faster)

Function  | Description
------------- | -------------
`interpose(with: S.Generator.Element) -> GeneratorOf<S.Generator.Element>` | returns a generator of the elements of self with "with" inserted between every element

```swift
Array(LazySequence([1, 2, 3, 4, 5]).interpose(6)) // [1, 6, 2, 6, 3, 6, 4, 6, 5, 6]
```

## Int ##
Function  | Description
------------- | -------------
`gcd(var a: Int) -> Int` | returns the greatest common divisor of self and a
`lcm(a: Int) -> Int` | returns the lowest common multiple of self and a

These use the Euclidean Algorithm.

Function  | Description
------------- | -------------
`digits() -> [Int]` | returns an array of the digits of self
`concat(x: Int) -> Int` | concatenates self with x

These functions operate on the digits of self, in base 10. The infix operator `|+` also performs concat.

```swift
345.digits() // [3, 4, 5]
34 |+ 56     // 3456
```

Function  | Description
------------- | -------------
`primesBelow() -> GeneratorOf<Int> ` | returns the primes below self
`primesFactors() -> GeneratorOf<Int> ` | returns the primes factors of self
`isPrime() -> Bool ` | returns true iff self is prime

Function  | Description
------------- | -------------
`times<T>(call: () -> T)` | repeats a function n times, where n is self

```swift
var i = 0

func incI ()->() { ++i }

4.times(incI)

i // 4
```

Function  | Description
------------- | -------------
`isEven() -> Bool` | returns true if self is even
`isOdd() -> Bool` | returns true if self is Odd

## String ##
Function  | Description
------------- | -------------
`split(ind: String.Index) -> [String]` | Splits a string at a given index
`split(inds: [String.Index]) -> [String]` | Splits a string at given indices
`split(ind: Int) -> [String]` | Splits a string at a given index
`split(inds: [Int]) -> [String]` | Splits a string at given indices

These functions all return an array of strings. If the function is given the `startIndex` or the index before the `endIndex`, it will have an empty string in the array. It can take either `String.Index`s or `Int`s. (String.Index is faster (But then again, it's strings in Swift so it's gonna be slow))

```swift
"hello".split(2)  	    // ["he", "llo"]
"hello".split([2, 3]) 	// ["he", "l", "lo"]
```

## RangesAndIntervals ##

### Open-Ended Ranges ###
Type  | Description
------------- | -------------
`struct OpenEndedRange<I: ForwardIndexType> { let start: I }` | A range containing only a start value
`struct OpenStartedRange<I: ForwardIndexType> { let end: I }` | A range containing only a start value

These structs and operators allow one-ended slicing, as by [Airspeed Velocity.](http://airspeedvelocity.net/2015/05/02/spelling//) The operators for these are `..<`.

```swift
let word = "Hello"
word[word.startIndex.successor()..<] // "ello"
```

### Closed Intervals ###
Function  | Description
------------- | -------------
`contains(with: ClosedInterval<T>) -> Bool` | Checks if one interval is contained entirely in the other
`span(with: ClosedInterval) -> ClosedInterval<T>` | returns the largest interval of which both ends are still inside at least one of the constituent intervals
`between(with: ClosedInterval<T>) -> ClosedInterval<T>` | returns an interval that is between two other intervals. If the intervals overlap, it will return an interval between the two overlapping ends
`subtract(with: ClosedInterval<T>) -> ClosedInterval<T>?` | returns self where no part of self except either the end or start is contained in the interval "with"

These functions operate on `ClosedInterval`s.

Operator  | Equivalent Function
------------- | -------------
`+` | `left.span(right)`
`-` | `left.subtract(right)`

### Generators and Helpers ###
Operator  | Description
------------- | -------------
`postfix func ... <I: ForwardIndexType>(var from: I) -> GeneratorOf<I>` | returns a generator of increments starting at self
`prefix func ... <I: BidirectionalIndexType>(var from: I) -> GeneratorOf<I>` | returns a generator of decrements starting at self

```swift
for i in 1... {
  print(i) 		// 1, 2, 3, 4, 5, 6, 7, 8, 9...
}

for i in ...1 {
  print(i) 		// 1, 0, -1, -2, -3, -4, -5, -6...
}
```

Operator  | Description
------------- | -------------
`...<T : Strideable>(lhs: (T, T), rhs: T) -> StrideThrough<T>` | returns a StrideThrough, with the distance between the two elements of the tuple taken to be the stride
`..<<T : Strideable>(lhs: (T, T), rhs: T) -> StrideTo<T> ` | returns a StrideThrough, with the distance between the two elements of the tuple taken to be the stride

```swift
for i in (2, 4)...10 {
  print(i) 		// 2, 4, 6, 8, 10
}

for i in (2, 4)..<10 {
  print(i) 		// 2, 4, 6, 8
}
```

Operator  | Description
------------- | -------------
`postfix func ... <T: Strideable>(steps: [T]) -> GeneratorOf<T>` | iterates through an array, and when the end is reached, continues on by striding the same distance as is between the last two elements of the array
`func ... <T: Strideable> (lhs: [T], rhs: T) -> GeneratorOf<T>` | iterates through an array, and when the end is reached, continues on by striding the same distance as is between the last two elements of the array, until the rhs value is reached. Stops at or before rhs.
`func ..< <T: Strideable> (lhs: [T], rhs: T) -> GeneratorOf<T>` | iterates through an array, and when the end is reached, continues on by striding the same distance as is between the last two elements of the array, until the rhs value is reached. Stops before rhs.

```swift
for i in [1, 2, 3, 5]... {
  print(i) // 1, 2, 3, 5, 7, 9, 11, 13...
}
for i in [1, 2, 3, 5]...11 {
  print(i) // 1, 2, 3, 5, 7, 9, 11
}
for i in [1, 2, 3, 5]..<11 {
  print(i) // 1, 2, 3, 5, 7, 9
}

```

# Utilities #
Function  | Description
------------- | -------------
`uniques<S: SequenceType where S.Generator.Element: Hashable> (seq: S) -> LazySequence<FilterSequenceView<S>>` | Returns a LazySequence of a sequence without repetitions, (much faster than the method on LazySequence, seeing as it uses Sets)

This is similar to the method on `LazySequence`, but since it uses `Set`s, its arguments need to be `Hashable`, and it is much faster.

Function  | Description
------------- | -------------
`all<S: SequenceType>(seq: S, condition: S.Generator.Element -> Bool) -> Bool` | Checks if all elements in seq satisfy the condition

This runs a closure over all elements of a sequence, and returns true if all of the elements return true.

Function  | Description
------------- | -------------
`nextLexPerm<T: Comparable>(inout a: [T]) -> [T]?` | Returns the next permutation of an array in lexicographical order
`lexPermsOf<T: Comparable>(var a: [T]) -> LazySequence<GeneratorOf<[T]>>` | Returns a Generator of permutations of a, in lexicographical order

These work the same as the methods on `Array`, but they don't need the `isOrderedBefore` closure, as their arguments need to be comparable.

Function  | Description
------------- | -------------
`xEnumerate<C: CollectionType>(base: C) -> LazySequence<Zip2<Range<C.Index>, C>>` | Return a LazySequence containing pairs (n, x), where *n*s are consecutive indices of base, and xs are the elements of base.

This function is similar to the standard `enumerate()`, but the indices returned are the indices of the underlying sequence. (`enumerate()` returns `Int`s, starting at 0)


Function  | Description
------------- | -------------
`find<C : CollectionType>(domain: C, predicate: C.Generator.Element -> Bool) -> C.Index?` | Returns the first index where a value satisfies a predicate or nil if one is not found.
`findMany<C : CollectionType where C.Generator.Element : Equatable>(domain: C, element: C.Generator.Element) -> LazySequence<FilterSequenceView<Range<C.Index>>>` | returns indices of elements that equal the element given
`findMany<C : CollectionType>(domain: C, include: C.Generator.Element -> Bool) -> LazySequence<FilterSequenceView<Range<C.Index>>>` | Returns the indices of elements that satisfy the include closure.
`findLast<C: CollectionType where C.Index: BidirectionalIndexType>(domain: C, condition: C.Generator.Element -> Bool) -> C.Index?` | Returns the first index where a value satisfies a condition or nil if one is not found.
`findLast<C: CollectionType where C.Index: BidirectionalIndexType, C.Generator.Element: Equatable>(domain: C, value: C.Generator.Element) -> C.Index?` | Returns the last index where value appears in domain or nil if value is not found.

These work the same as the standard `find()` function, except they can take a closure, and can return multiple indices.

Function  | Description
------------- | -------------
`contains<S0: SequenceType, S1: SequenceType, T: Equatable where  S0.Generator.Element == T, S1.Generator.Element == T> (outer: S0, inner: S1) -> Bool` | returns true if outer entirely contains inner
`replace <S: SequenceType where S.Generator.Element: Hashable> (seq: S, replacements: [S.Generator.Element:S.Generator.Element]) -> LazySequence<GeneratorOf<S.Generator.Element>>` | replaces every element in seq that corresponds to a key in replacements with the value in replacements

```swift
contains([1, 2, 3, 4], [2, 3, 4]) 		// true
contains([1, 2, 3, 4], [3, 4, 5]) 		// false

contains("hello", "llo") 			// true
contains("hiya", "llo") 			// false

replace([1, 2, 3, 4], [2:8]).array 		// [1, 8, 3, 4]

let str = "tebbo"
String(replace(str, ["t": "h", "b": "l"])) 	// "hello"
```


Function  | Description
------------- | -------------
`catByClosure<K: Hashable, S: SequenceType>(seq: S, clos: [K:(S.Generator.Element -> Bool)]) -> [K : [S.Generator.Element]]` | Categorises elements of a sequence according to closures.
`histo<S: SequenceType where S.Generator.Element: Hashable>(seq: S) -> [S.Generator.Element:Int]` | returns a dictionary of which the keys are the elements in seq, and the values are the number of times each element occurs
`histoByClosure<K: Hashable, S: SequenceType>(seq: S, clos: [K:(S.Generator.Element -> Bool)]) -> [K : Int]` | returns a dictionary of which the keys are the keys of clos in seq, and the values are the number of elements that match for each closure in clos


```swift
let isEven = {$0 % 2 == 0}
let isOdd = {$0 % 2 != 0}
let isSmall = {$0 < 5}

let catagories = ["even" : isEven, "odd" : isOdd, "small" : isSmall]

let nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

catByClosure(nums, catagories)

//[
//  "even": [2, 4, 6, 8, 10],
//  "odd": [1, 3, 5, 7, 9],
//  "small": [1, 2, 3, 4]
//]

histo([1, 2, 3, 3, 4, 2, 2, 2, 1]) // [2: 4, 3: 2, 1: 2, 4: 1]

histoByClosure(nums, catagories)  // ["even": 5, "odd": 5, "small": 4]
```


Function  | Description
------------- | -------------
`skipNil<S: SequenceType, T where S.Generator.Element == T?>(seq: S) -> GeneratorOf<T> ` | returns a generator with all optionals unwrapped, and any that evaluate to nil removed

```swift
let seq: [Int?]
seq = [1, nil, 2, nil, 3, nil]
Array(skipNil(seq)) // [1, 2, 3]
```

Function  | Description
------------- | -------------
`filterMap<S: SequenceType, T>(seq: S, map: S.Generator.Element -> T, filter: S.Generator.Element -> Bool) -> GeneratorOf<T>` | filters and maps at once
`flatten <S: SequenceType where S.Generator.Element: SequenceType> (seq: S) -> GeneratorOf<S.Generator.Element.Generator.Element>` | a lazy flatten function that produces a generator
`memoize<T: Hashable, U>(f: (T -> U)) -> (T -> U)` | simple memoizer

```swift
func fib(n: Int) -> Int {
  
  return n < 2 ? n : fib(n - 1) + fib(n - 2)
  
}

let memFib = memoize(fib)

memFib(10) // calculates

memFib(10) // no calculation
```
