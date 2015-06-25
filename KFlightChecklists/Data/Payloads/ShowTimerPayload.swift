//
//  ShowTimerPayload.swift
//  KFlightChecklists
//
//  Created by Congee on 6/24/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class ShowTimerPayload : Payload {
    var duration : Float?
    
    init(_ item: String?, _ action: String?,
        _ duration : Float?, completionCallback: CompletionCallback?)
    {
        super.init(item, action, completionCallback)
        self.duration = duration
    }
}