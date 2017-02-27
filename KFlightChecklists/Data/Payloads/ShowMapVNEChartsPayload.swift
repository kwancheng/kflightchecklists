//
//  ShowMapVNEChartsPayload.swift
//  KFlightChecklists
//
//  Created by Congee on 7/6/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

open class ShowMapVNEChartsPayload : Payload {
    open var oat : Float = 10
    
    public init(_ oat : Float, _ item:String?, _ action: String?, completionCallback:CompletionCallback?) {
        super.init(item, action, completionCallback)
        
        self.oat = oat
    }
}
