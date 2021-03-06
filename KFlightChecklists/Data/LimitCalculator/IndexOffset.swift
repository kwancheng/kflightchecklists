//
//  IndexOffset.swift
//  KFlightChecklists
//
//  Created by Congee on 7/1/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

open class IndexOffSet {
    open var index : Int
    open var offset: Int
    
    fileprivate init(index: Int, offset: Int) {
        self.index = index
        self.offset = offset
    }
    
    public init(value:Int, rangeInfo:RangeInfo) {
        let nRange = value + rangeInfo.normalizeBy
        self.index = nRange / rangeInfo.stepVal
        self.offset = nRange % rangeInfo.stepVal
    }
    
    open func advanceIndex() -> IndexOffSet {
        return IndexOffSet(index:self.index+1, offset:self.offset)
    }
}
