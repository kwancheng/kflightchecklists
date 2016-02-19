//
//  HobbsReadingViewController.swift
//  KFlightChecklists
//
//  Created by Congee on 6/23/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class HobbsReadingViewController : NotepadViewController, UITextFieldDelegate {
    @IBOutlet var tbReadingHours : UITextField?
    @IBOutlet var tbReadingHoursFractional : UITextField?
    @IBOutlet var lblTitleLabel : UILabel?
    
    private var reading : Float?
    private var isPreFlight : Bool?
    private var setHobbsMeterReadingCallback : ((isPreFlight : Bool, reading : Float)->Void)?
    private var completionCallback : (()->Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tbReadingHours?.delegate = self
        tbReadingHoursFractional?.delegate = self
        
        let prefix = (isPreFlight ?? false) ? "Pre" : "Post"

        

        lblTitleLabel?.text = String(format: "%@Flight Hobbs Reading", prefix)

    }

    

    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        let newLength = textField.text!.utf16.count + string.utf16.count - range.length

        return newLength <= textField.tag

    }

    

    public func setPayload(payload : RecordHobbsMeterReadingPayload) {

        self.reading = payload.reading

        self.isPreFlight = payload.isPreFlight

        self.setHobbsMeterReadingCallback = payload.setHobbsMeterReadingCallback

        self.completionCallback = payload.completionCallback

    }

    

    @IBAction func returnToList(sender : AnyObject) {

        var hours = 0

        if tbReadingHours!.text!.characters.count > 0 {

            hours = Int(tbReadingHours!.text!)!

        }

        

        var fHours = 0

        if tbReadingHoursFractional!.text!.characters.count > 0 {

            fHours = Int(tbReadingHoursFractional!.text!)!
        }
        
        let reading = Float(hours) + (Float(fHours) / 10)

        if let setHobbsMeterReadingCallback = self.setHobbsMeterReadingCallback {
            let isPreFlight = self.isPreFlight ?? false
            setHobbsMeterReadingCallback(isPreFlight: isPreFlight, reading: reading)
        }
        
        self.dismissViewControllerAnimated(true, completion: completionCallback)
    }
}
