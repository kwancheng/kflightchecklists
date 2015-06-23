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
    public var duration : Int?
    
    public override init(_ jsonData: JSON){
        super.init(jsonData)
        duration = jsonData["duration"].intValue
    }
}