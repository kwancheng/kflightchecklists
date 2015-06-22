//
//  ShowHobbsMeterNotepadAction.swift
//  KFlightChecklists
//
//  Created by Congee on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class RecordHobbsMeterReadingAction : Action {
    var isPreFlight : Bool?
    
    public override init(_ jsonData : JSON){
        super.init(jsonData)
        isPreFlight = jsonData["pre_flight"].bool
    }
}