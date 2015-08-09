//
//  AgreementViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 8/8/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class AgreementViewController : UIViewController {
    @IBAction func agreementAccepted(sender : AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("agreed", forKey: "agreed")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}