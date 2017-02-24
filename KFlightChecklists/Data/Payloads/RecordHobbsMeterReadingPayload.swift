//
//  RecordHobbsMeterReadingPayload.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/22/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public typealias SetHobbsMeterReadingCallback = (_ isPreFlight : Bool, _ reading : Float)->Void

open class RecordHobbsMeterReadingPayload : Payload {
    open var isPreFlight : Bool?
    open var reading : Float?
    open var setHobbsMeterReadingCallback : SetHobbsMeterReadingCallback?

    init(_ item: String?, _ action: String?,
        _ isPreFlight : Bool?, _ reading : Float?,
        _ setHobbsMeterReadingCallback : SetHobbsMeterReadingCallback?,
        _ completionCallback: CompletionCallback?)
    {
        super.init(item, action, completionCallback)
        
        self.isPreFlight = isPreFlight
        self.reading = reading
        self.setHobbsMeterReadingCallback = setHobbsMeterReadingCallback
    }
}
