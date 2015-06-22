//
//  ActionFactory.swift
//  KFlightChecklists
//
//  Created by Congee on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

func instantiateActionFromJson(jsonData : JSON) -> Action? {
    var retAction : Action?
    
    if let actionName = jsonData["name"].string {
        switch actionName {
            case "ShowMessage" :
                retAction = ShowMessageAction(jsonData)
            case "RecordFuelQuantity" :
                retAction = RecordFuelQuantityAction(jsonData)
            case "RecordHobbsMeterReading" :
                retAction = RecordHobbsMeterReadingAction(jsonData)
            case "StartFlightTimter" :
                retAction = StartFlightTimerAction(jsonData)
            case "StopFlightTimer" :
                retAction = StopFlightTimerAction(jsonData)
            case "ShowTimer" :
                retAction = ShowTimerAction(jsonData)
            default :
                break
        }
    }
    
    return retAction
}