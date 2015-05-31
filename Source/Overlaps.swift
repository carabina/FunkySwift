//
//  Overlaps.swift
//  FunkySwift
//
//  Created by Donnacha Oisín Kidney on 31/05/2015.
//  Copyright (c) 2015 Donnacha Oisín Kidney. All rights reserved.
//

import Foundation


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

func startTheSame
  <S0: SequenceType,
  S1: SequenceType,
  T: Equatable where
  S0.Generator.Element == T,
  S1.Generator.Element == T>
  (s0: S0, s1: S1) -> Bool {
    var (g0, g1) = (s0.generate(), s1.generate())
    if let a = g0.next(), b = g1.next() where a == b {
      while let e0 = g0.next(), e1 = g1.next() { if e0 != e1 { return false } }
      return true
    } else {
      return false
    }
}

func overlapsInOrder
  <S0: SequenceType,
  S1: SequenceType,
  T: Equatable where
  S0.Generator.Element == T,
  S1.Generator.Element == T>
  (s0: S0, s1: S1) -> Bool {
    var g1 = s1.generate()
    do { if startTheSame(s0, GeneratorSequence(g1)) { return true }
    } while g1.next() != nil
    return false
}

func overlaps
  <S0: SequenceType,
  S1: SequenceType,
  T: Equatable where
  S0.Generator.Element == T,
  S1.Generator.Element == T>
  (s0: S0, s1: S1) -> Bool { return overlapsInOrder(s0, s1) || overlapsInOrder(s1, s0) }

func ifIsPrefix
  <S0: SequenceType,
  S1: SequenceType,
  T: Equatable where
  S0.Generator.Element == T,
  S1.Generator.Element == T>
  (s0: S0, s1: S1) -> GeneratorOf<T>? {
    var (g0, g1) = (s0.generate(), s1.generate())
    if let e0 = g0.next(), e1 = g1.next() where e0 == e1 {
      while let e0 = g0.next(), e1 = g1.next() { if e0 != e1 { return nil } }
      (g0, g1) = (s0.generate(), s1.generate())
      return GeneratorOf{
        if let e0 = g0.next(), e1 = g1.next() {
          return e0
        } else {
          return nil
        }
      }
    } else {return nil}
}

func overlapInOrder
  <S0: SequenceType,
  S1: SequenceType,
  T: Equatable where
  S0.Generator.Element == T,
  S1.Generator.Element == T>
  (s0: S0, s1: S1) -> GeneratorOf<T>? {
    var g1 = s1.generate()
    do { if let gen = ifIsPrefix(s0, GeneratorSequence(g1)) { return gen }
    } while g1.next() != nil
    return nil
}

func overlap
  <S0: SequenceType,
  S1: SequenceType,
  T: Equatable where
  S0.Generator.Element == T,
  S1.Generator.Element == T>
  (s0: S0, s1: S1) -> (SequenceOf<T>?, SequenceOf<T>?) {
    return (overlapInOrder(s0, s1).map{SequenceOf($0)}, overlapInOrder(s1, s0).map{SequenceOf($0)})
}

func commonPrefix
  <S0: SequenceType,
  S1: SequenceType,
  T: Equatable where
  S0.Generator.Element == T,
  S1.Generator.Element == T>
  (s0: S0, s1: S1) -> SequenceOf<T>? {
    var (g0, g1) = (s0.generate(), s1.generate())
    if let e0 = g0.next(), e1 = g1.next() where e0 == e1 {
      (g0, g1) = (s0.generate(), s1.generate())
      return SequenceOf{ GeneratorOf{
        if let e0 = g0.next(), e1 = g1.next() where e0 == e1 {
          return e0
        } else {
          return nil
        }
        } }
    } else {return nil}
}