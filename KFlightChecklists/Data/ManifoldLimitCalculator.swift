//
//  ManifoldLimitCalculator.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/27/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class ManifoldLimiteCalculator {
    private let limitTable : [[Double]] = [
        [21.5, 21.8, 22.1, 22.3, 22.6, 22.9, 23.2],
        [21.1, 21.4, 21.6, 21.9, 22.2, 22.5, 22.8],
        [20.7, 21.0, 21.2, 21.5, 21.8, 22.0, 22.3],
        [20.3, 20.6, 20.8, 21.1, 21.3, 21.6, 21.9],
        [19.9, 20.2, 20.4, 20.7, 20.9, -1,   -1  ]
    ]

    private func getOatIndex(oat: Int) -> Int? {
        var retVal : Int? = nil
        
        if oat >= -20 && oat <= 40 {
            var nRange = oat + 20
            retVal = nRange / 10
        }
        
        return retVal
    }
    
    private func calculateMap(altIndex: Int, _ oatIndex: Int, _ oatOffset:Int) -> Double? {
        var retVal : Double? = nil
        
        let altIndexIsValid = altIndex >= 0 && altIndex < 5
        let oatIndexIsValid = oatIndex >= 0 && oatIndex < 7
        
        if altIndexIsValid && oatIndexIsValid {
            var mapLow = limitTable[altIndex][oatIndex]
            
            // figure out upper range
            var mapHigh = mapLow
            if (oatIndex+1) < 7 {
                mapHigh = limitTable[altIndex][oatIndex+1]
            }
            
            // detect full throttle condition
            if mapLow == -1 || (mapHigh == -1 && oatOffset != 0){
                retVal = -2
            } else {
                if mapHigh == -1{
                    mapHigh == mapLow
                }
                
                let mapDelta = mapHigh - mapLow
                let mapStep = mapDelta / 10
                let mapOffset = Double(oatOffset) * mapStep
                retVal = mapLow + mapOffset
            }
        }
        
        return retVal
    }
    
    public func getManifoldPressureAtAltitude(altitude: Int, oat: Int) -> Double? {
        var retVal : Double? = nil
        
        let altIsValid = altitude >= 0 && altitude <= 8000
        let oatIsValid = oat >= -20 && oat <= 40
        
        if altIsValid && oatIsValid {
            let altIndex = altitude / 2000
            let altOffset = altitude % 2000
            
            let nOat = oat + 20
            let oatIndex = nOat / 10
            let oatOffset = nOat % 10
            
            if let mapAtLowAlt = calculateMap(altIndex, oatIndex, oatOffset) {
                if mapAtLowAlt == -2 {
                    retVal = -2 // full throtle
                } else {
                    var mapAtHighAlt = calculateMap(altIndex+1, oatIndex, oatOffset) ?? mapAtLowAlt
                    
                    if mapAtHighAlt == -2 && altOffset != 0 {
                        retVal = -2
                    } else {
                        var mapDelta = mapAtLowAlt - mapAtHighAlt
                        var mapStep = mapDelta / Double(2000)
                        
                        var mapOffset = Double(altOffset) * mapStep
                        retVal = mapAtLowAlt + mapOffset
                    }
                }
            }
        }
        
        return retVal
    }
}