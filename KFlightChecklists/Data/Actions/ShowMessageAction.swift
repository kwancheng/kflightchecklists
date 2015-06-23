//
//  ShowMessageAction.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/19/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ShowMessageAction : Action {
    public var message : String?
    
    override init(_ jsonData: JSON) {
        super.init(jsonData)
        self.message = jsonData["message"].string
    }
    
    public override func execute(viewController: UIViewController, _ payload: Payload?) {
        super.execute(viewController, payload)
        
        if let payload = payload {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                if let callback = payload.completionCallback {
                    callback()
                }
            })
            alertController.addAction(defaultAction)
            dispatch_async(dispatch_get_main_queue(), {()->Void in
                viewController.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
}