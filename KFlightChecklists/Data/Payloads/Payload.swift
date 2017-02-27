//
//  Payload.swift
//  KFlightChecklists
//
//  Created by Congee on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

open class Payload {
    var item : String?
    var action : String?
    var completionCallback : CompletionCallback?
    
    public init(_ item : String?, _ action : String?, _ completionCallback : CompletionCallback?) {
        self.item = item
        self.action = action
        self.completionCallback = completionCallback
    }
}
