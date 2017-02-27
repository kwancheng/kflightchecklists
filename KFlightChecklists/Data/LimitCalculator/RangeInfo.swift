//
//  RangeInfo.swift
//  KFlightChecklists
//
//  Created by Congee on 7/1/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

open class RangeInfo {
    open var count : Int // aka number of columns
    open var minVal : Int // aka the value of column 0
    open var maxVal : Int // aka the value of the last column
    open var stepVal : Int // aka the value between the columns
    open var normalizeBy : Int // aka if value is negative, bring it to positive
    
    public init(count:Int, minVal:Int, maxVal:Int, stepVal:Int, normalizeBy:Int) {
        self.count = count
        self.minVal = minVal
        self.maxVal = maxVal
        self.stepVal = stepVal
        self.normalizeBy = normalizeBy
    }
}
