//
//  ShowTimerPayload.swift
//  KFlightChecklists
//
//  Created by Congee on 6/24/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

open class ShowTimerPayload : Payload {
    var duration : Int?
    
    public init(_ item: String?, _ action: String?,
        _ duration : Int?, completionCallback: CompletionCallback?)
    {
        super.init(item, action, completionCallback)
        self.duration = duration
    }
}
