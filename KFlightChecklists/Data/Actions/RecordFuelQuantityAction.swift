//
//  ShowFuelQuantityNotepadAction.swift
//  KFlightChecklists
//
//  Created by Congee on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class RecordFuelQuantityAction : Action {
    public func makePayload<PayloadType:RecordFuelQuantityPayload>(
        itemString : String?, _ actionString : String?,
        setFuelLevelCallback : ((mainTankLevel : Float, auxTankLevel : Float)->Void)?,
        completionCallback : (()->Void)?
        ) -> PayloadType
    {
        var retVal = PayloadType()
        retVal.itemStr = itemString
        retVal.actionStr = actionString
        retVal.setFuelLevelCallback = setFuelLevelCallback
        retVal.completionCallback = completionCallback
        return retVal
    }
    
    public override func execute(viewController: UIViewController, _ payload: Payload?) {
        super.execute(viewController, payload)
        dispatch_async(dispatch_get_main_queue(), {()->Void in
            viewController.performSegueWithIdentifier("ShowFuelQuantityNotepad", sender: payload)
        })
    }
}