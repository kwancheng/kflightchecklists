//
//  ShowTimerAction.swift
//  KFlightChecklists
//
//  Created by Congee on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ShowTimerAction : Action {
    public var durationInSeconds : Int?
    
    public override init(_ jsonData: JSON){
        super.init(jsonData)
        durationInSeconds = jsonData["duration"].intValue
    }
}