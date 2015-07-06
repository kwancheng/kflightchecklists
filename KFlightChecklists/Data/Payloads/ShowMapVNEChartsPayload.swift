//
//  ShowMapVNEChartsPayload.swift
//  KFlightChecklists
//
//  Created by Congee on 7/6/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class ShowMapVNEChartsPayload : Payload {
    public init(_ item:String?, _ action: String?, completionCallback:CompletionCallback?) {
        super.init(item, action, completionCallback)
    }
}