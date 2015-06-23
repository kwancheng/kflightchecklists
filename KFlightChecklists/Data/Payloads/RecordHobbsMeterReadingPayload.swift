//
//  RecordHobbsMeterReadingPayload.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/22/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class RecordHobbsMeterReadingPayload : Payload {
    public var isPreFlight : Bool?
    public var reading : Float?
    public var setHobbsMeterReadingCallback : ((isPreFlight : Bool, reading : Float)->Void)?
}
