//
//  AgreementViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 8/8/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class AgreementViewController : UIViewController {
    @IBAction func agreementAccepted(_ sender : AnyObject) {
        let defaults = UserDefaults.standard
        defaults.setValue("agreed", forKey: "agreed")
        
        dismiss(animated: true, completion: nil)
    }
}
