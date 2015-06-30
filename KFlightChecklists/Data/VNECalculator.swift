//
//  VNECalculator.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/28/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class VNECalculator {
    private let vneTable : [[Int]] = [
        [102, 102, 102, 102, 102, 102, 102], // SL
        [102, 102, 102, 102, 102,  99,  96], // 2000
        [102, 102, 102,  98,  94,  91,  87], // 4000
        [102,  98,  94,  90,  87,  82,  77], // 6000
        [ 94,  90,  86,  80,  75,  69,  64], // 8000
        [ 86,  80,  74,  68,  62,  57,  -1], // 10000
        [ 74,  67,  61,  -1,  -1,  -1,  -1], // 12000
        [ 61,  -1,  -1,  -1,  -1,  -1,  -1]  // 14000
    ]
    
    private class IndexOffset {
        var index : Int
        var offset : Int
        
        init(index: Int, offset:Int){
            self.index = index
            self.offset = offset
        }
    }
    
    private func getOatIndexOffset( oat: Int ) -> IndexOffset? {
        var oatIndexOffset : IndexOffset? = nil
        
        if oat >= -20 && oat <= 40 {
            var nRange = oat+20
            var index = nRange / 10
            var offset = nRange % 10
            
            oatIndexOffset = IndexOffset(index: index, offset: offset)
        }
        
        return oatIndexOffset
    }
    
    private func getAltIndexOffset(altitude:Int) -> IndexOffset? {
        var indexOffset : IndexOffset? = nil
        
        if altitude >= 0 && altitude <= 14000 {
            var index = altitude / 2000
            var offset = altitude % 2000
            indexOffset = IndexOffset(index: index, offset: offset)
        }
        
        return indexOffset
    }
    
    private func calcOatAtAlt(altIndex:Int,_ oatMinIndex:Int,_ oatMaxIndex:Int,_ oatOffset: Int) -> Double {
        var retVal : Double = -1.0
        
        var vneOatMin = Double(vneTable[altIndex][oatMinIndex])
        if vneOatMin != -1 {
            var vneOatMax = Double(vneTable[altIndex][oatMaxIndex])
            if vneOatMax != -1 || oatOffset == 0 {
                if vneOatMax == -1 {
                    vneOatMax = vneOatMin
                }
                
                let delta = vneOatMax - vneOatMin
                let step = delta / 10
                let offset = Double(oatOffset) * step
                retVal = vneOatMin + offset
            }
        }
        
        return retVal
    }
    
    func calculateVne(altitude: Int, oat:Int) -> Double? {
        var vne : Double? = nil
        
        if let altMin = getAltIndexOffset(altitude) {
            if let oatMin = getOatIndexOffset(oat) {
                var altMax = altMin
                if altMin.index + 1 < 8 {
                    altMax = IndexOffset(index:altMin.index+1, offset: altMin.offset)
                }
                
                var oatMax = oatMin
                if oatMin.index + 1 < 7 {
                    oatMax = IndexOffset(index: oatMin.index+1, offset: oatMin.offset)
                }
                
                let vneLowAlt = calcOatAtAlt(altMin.index, oatMin.index, oatMax.index, oatMin.offset)
                
                vne = -1
                
                if vneLowAlt != -1 {
                    var vneHighAlt = calcOatAtAlt(altMax.index, oatMin.index, oatMax.index, oatMin.offset)
                    
                    if vneHighAlt != -1 || altMin.offset == 0 {
                        if vneHighAlt == -1 {
                            vneHighAlt = vneLowAlt
                        }
                        let delta = vneHighAlt - vneLowAlt
                        let step = delta / 2000
                        let offset = step * Double(altMin.offset)
                        vne = vneLowAlt + offset
                    }
                }
                
            }
        }
        
        return vne
    }

}