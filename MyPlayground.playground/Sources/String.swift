//
//  String.swift
//  FuncySwift
//
//  Created by Donnacha Oisín Kidney on 27/05/2015.
//
//

import Foundation

extension String {
  
  /**
  Splits a string at a given index
  
  :param: ind The index at which to split the string
  :returns: An array with two elements: the first and second part of the string
  */
  
  func split(ind: String.Index) -> [String] {
    return [self.substringToIndex(ind), self.substringFromIndex(ind)]
  }
  
  /**
  Splits a string at given indices
  
  :param: inds an array of indices at which to split the string
  :returns: An array of the split strings
  */
  
  func split(inds: [String.Index]) -> [String] {
    return multiSplit(sorted(inds))
  }
  
  /**
  Recursive helper function for splitting a string at several indices
  */
  
  private func multiSplit(var inds: [String.Index]) -> [String] {
    
    if inds.isEmpty { return [self] } else {
      
      let ind = inds.removeLast()
      
      return self.substringToIndex(ind)
        .multiSplit(inds)
        + [self.substringFromIndex(ind)]
      
    }
  }
  
  /**
  Splits a string at a given index
  
  :param: ind The index at which to split the string
  :returns: An array with two elements: the first and second part of the string
  */
  
  func split(ind: Int) -> [String] {
    return split(advance(self.startIndex, ind))
  }
  
  /**
  Splits a string at given indices
  
  :param: inds an array of indices at which to split the string
  :returns: An array of the split strings
  */
  
  func split(inds: [Int]) -> [String] {
    return split(inds.map{advance(self.startIndex, $0)})
  }

}