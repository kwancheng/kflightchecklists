//
//  ManifoldLimitCalculator.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/27/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class ManifoldLimiteCalculator : LimitCalculator {
    private let limitTable : [[Double]] = [
        [21.5, 21.8, 22.1, 22.3, 22.6, 22.9, 23.2],
        [21.1, 21.4, 21.6, 21.9, 22.2, 22.5, 22.8],
        [20.7, 21.0, 21.2, 21.5, 21.8, 22.0, 22.3],
        [20.3, 20.6, 20.8, 21.1, 21.3, 21.6, 21.9],
        [19.9, 20.2, 20.4, 20.7, 20.9, -1,   -1  ]
    ]
    
    private let oatRange = RangeInfo(count: 7, minVal: -20, maxVal: 40, stepVal: 10, normalizeBy: 20)
    private let altRange = RangeInfo(count: 5, minVal: 0, maxVal: 8000, stepVal: 2000, normalizeBy: 0)
    
    public init() {
        super.init(xRangeInfo: oatRange, yRangeInfo: altRange, limitTable: limitTable)
    }

    public func calcMapLimit(altitude:Int, oat: Int) -> Double? {
        return calcLimitAt(oat, y: altitude)
    }
}