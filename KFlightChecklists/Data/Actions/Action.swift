//
//  Action.swift
//  KFlightChecklists
//
//  Created by Congee on 6/17/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Action {
    public var name : String?
    
    public init(_ jsonData : JSON) {
        self.name = jsonData["name"].string
    }
    
    public func makePayload<PayloadType:Payload>(itemString : String?, _ actionString: String?, _ completionCallback : (()->Void)?) -> PayloadType {
        var retVal = PayloadType()
        retVal.itemStr = itemString
        retVal.actionStr = actionString
        retVal.completionCallback = completionCallback
        return retVal
    }
    
    public func execute(viewController : UIViewController,
        _ payload : Payload?) {}
    
    static public func instantiateActionFromJson(jsonData : JSON) -> Action? {
        var retAction : Action?
        
        if let actionName = jsonData["name"].string {
            switch actionName {
            case "ShowMessage" :
                retAction = ShowMessageAction(jsonData)
            case "RecordFuelQuantity" :
                retAction = RecordFuelQuantityAction(jsonData)
            case "RecordHobbsMeterReading" :
                retAction = RecordHobbsMeterReadingAction(jsonData)
            case "StartFlightTimer" :
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
}