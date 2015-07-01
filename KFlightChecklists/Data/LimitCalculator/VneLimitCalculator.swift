//
//  VNECalculator.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/28/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class VneLimitCalculator : LimitCalculator {
    private let vneTable : [[Double]] = [
        [102, 102, 102, 102, 102, 102, 102], // SL
        [102, 102, 102, 102, 102,  99,  96], // 2000
        [102, 102, 102,  98,  94,  91,  87], // 4000
        [102,  98,  94,  90,  87,  82,  77], // 6000
        [ 94,  90,  86,  80,  75,  69,  64], // 8000
        [ 86,  80,  74,  68,  62,  57,  -1], // 10000
        [ 74,  67,  61,  -1,  -1,  -1,  -1], // 12000
        [ 61,  -1,  -1,  -1,  -1,  -1,  -1]  // 14000
    ]
    private let oatRangeInfo = RangeInfo(count: 7, minVal: -20, maxVal: 40, stepVal: 10, normalizeBy: 20)
    private let altRangeInfo = RangeInfo(count: 8, minVal: 0, maxVal: 14000, stepVal: 2000, normalizeBy: 0)
    
    public init() {
        super.init(xRangeInfo: oatRangeInfo, yRangeInfo: altRangeInfo, limitTable: vneTable)
    }
    
    func calculateVne(altitude: Int, oat:Int) -> Double? {
        return calcLimitAt(oat, y: altitude)
    }
}