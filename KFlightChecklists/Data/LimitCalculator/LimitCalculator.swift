//
//  LimitCalculator.swift
//  KFlightChecklists
//
//  Created by Congee on 7/1/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class LimitCalculator {
    private let limitTable : [[Double]]
    private let xRangeInfo : RangeInfo
    private let yRangeInfo : RangeInfo
    
    public init(xRangeInfo:RangeInfo, yRangeInfo:RangeInfo, limitTable:[[Double]]) {
        self.limitTable = limitTable
        self.xRangeInfo = xRangeInfo
        self.yRangeInfo = yRangeInfo
    }
    
    private func interpolateMinVal(minVal:Double, MaxVal maxVal:Double, offset:Double, stepVal:Double) -> Double {
        var retVal = -1.0
        
        if minVal != -1 {
            var tMaxVal = minVal
            if maxVal != -1 || offset == 0 {
                if maxVal != -1 {
                    tMaxVal = maxVal
                }
                
                let d = tMaxVal - minVal
                let s = d / stepVal
                let o = offset * s
                retVal = minVal + o
            }
        }
        
        return retVal
    }
    
    /*
    returns nil, if the x and y values are out of bounds
    returns the interpolate range of the values specified by x and y
    */
    func calcLimitAt(x : Int, y : Int) -> Double? {
        var limit : Double? = nil
        
        let validX = x >= xRangeInfo.minVal && x <= xRangeInfo.maxVal
        let validY = y >= yRangeInfo.minVal && y <= yRangeInfo.maxVal
        
        if validX && validY  {
            let xMin = IndexOffSet(value: x, rangeInfo: xRangeInfo)
            let yMin = IndexOffSet(value: y, rangeInfo: yRangeInfo)
            
            // clamp the edges
            var xMax = xMin
            if xMin.index + 1 < xRangeInfo.count {
                xMax = xMin.advanceIndex()
            }
            
            var yMax = yMin
            if yMin.index + 1 < yRangeInfo.count {
                yMax = yMin.advanceIndex()
            }
            
            let yMinVal = interpolateMinVal(

                limitTable[yMin.index][xMin.index],

                MaxVal: limitTable[yMin.index][xMax.index],

                offset: Double(xMin.offset),

                stepVal: Double(xRangeInfo.stepVal))

            let yMaxVal = interpolateMinVal(
                limitTable[yMax.index][xMin.index],
                MaxVal: limitTable[yMax.index][xMax.index],
                offset: Double(xMin.offset),
                stepVal: Double(xRangeInfo.stepVal))
            limit = interpolateMinVal(
                yMinVal,
                MaxVal: yMaxVal,
                offset: Double(yMin.offset),
                stepVal: Double(yRangeInfo.stepVal))
        }
        
        return limit
    }
}
