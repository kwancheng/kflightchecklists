//
//  ShowFuelQuantityNotepadPayload.swift
//  KFlightChecklists
//
//  Created by Congee on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

open class RecordFuelQuantityPayload : Payload {
    var setFuelLevelCallback : SetFuelLevelCallback?
    
    public init(_ item: String?, _ action: String?,
        _ setFuelLevelCallback : SetFuelLevelCallback?,
        _ completionCallback: CompletionCallback?)
    {
        super.init(item, action, completionCallback)
        self.setFuelLevelCallback = setFuelLevelCallback
    }
}
