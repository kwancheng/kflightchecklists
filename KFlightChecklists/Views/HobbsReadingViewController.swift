//
//  HobbsReadingViewController.swift
//  KFlightChecklists
//
//  Created by Congee on 6/23/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class HobbsReadingViewController : NotepadViewController, UITextFieldDelegate {
    @IBOutlet var tbReadingHours : UITextField?
    @IBOutlet var tbReadingHoursFractional : UITextField?
    @IBOutlet var lblTitleLabel : UILabel?
    
    fileprivate var reading : Float?
    fileprivate var isPreFlight : Bool?
    fileprivate var setHobbsMeterReadingCallback : ((_ isPreFlight : Bool, _ reading : Float)->Void)?
    fileprivate var completionCallback : (()->Void)?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        tbReadingHours?.delegate = self
        tbReadingHoursFractional?.delegate = self
        
        let prefix = (isPreFlight ?? false) ? "Pre" : "Post"

        

        lblTitleLabel?.text = String(format: "%@Flight Hobbs Reading", prefix)

    }

    

    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let newLength = textField.text!.utf16.count + string.utf16.count - range.length

        return newLength <= textField.tag

    }

    

    open func setPayload(_ payload : RecordHobbsMeterReadingPayload) {

        self.reading = payload.reading

        self.isPreFlight = payload.isPreFlight

        self.setHobbsMeterReadingCallback = payload.setHobbsMeterReadingCallback

        self.completionCallback = payload.completionCallback

    }

    

    @IBAction func returnToList(_ sender : AnyObject) {

        var hours = 0

        if tbReadingHours!.text!.count > 0 {

            hours = Int(tbReadingHours!.text!)!

        }

        

        var fHours = 0

        if tbReadingHoursFractional!.text!.count > 0 {

            fHours = Int(tbReadingHoursFractional!.text!)!
        }
        
        let reading = Float(hours) + (Float(fHours) / 10)

        if let setHobbsMeterReadingCallback = self.setHobbsMeterReadingCallback {
            let isPreFlight = self.isPreFlight ?? false
            setHobbsMeterReadingCallback(isPreFlight, reading)
        }
        
        self.dismiss(animated: true, completion: completionCallback)
    }
}
