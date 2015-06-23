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
        isPreFlight = jsonData["is_pre_flight"].bool
    }
    
    public func makePayload<PayloadType: RecordHobbsMeterReadingPayload>(
        itemString : String?, _ actionString : String?,
        _ preFlightHobbsReading : Float?, _ postFlightHobbsReading : Float?,
        setHobbsMeterReadingCallback : ((isPreFlight : Bool, reading : Float)->Void)?,
        completionCallback : (()->Void)?) -> PayloadType
    {
        var retVal = PayloadType()
        retVal.itemStr = itemString
        retVal.actionStr = actionString
        retVal.isPreFlight = self.isPreFlight
        retVal.reading = (isPreFlight ?? false) ? preFlightHobbsReading : postFlightHobbsReading
        retVal.setHobbsMeterReadingCallback = setHobbsMeterReadingCallback
        retVal.completionCallback = completionCallback
        return retVal
    }
    
    public override func execute(viewController: UIViewController, _ payload: Payload?) {
        super.execute(viewController, payload)
        dispatch_async(dispatch_get_main_queue(), {()->Void in
            viewController.performSegueWithIdentifier("ShowHobbsReadingNotepad", sender: payload)
        })
    }
}