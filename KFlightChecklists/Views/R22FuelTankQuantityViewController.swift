//
//  R22FuelTankQuantityViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/16/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class R22FuelTankQuantityViewController : NotepadViewController {
    @IBOutlet fileprivate var lblMain : UILabel!
    @IBOutlet fileprivate var sldrMain : UISlider!
    @IBOutlet fileprivate var lblAux : UILabel!
    @IBOutlet fileprivate var sldrAux : UISlider!
    @IBOutlet var lblItem : UILabel?
    @IBOutlet var lblAction : UILabel?
    
    var completionCallback : (()->Void)? = nil
    var setFuelLevelCallback : ((_ mainGallons:Float, _ auxGallons:Float) -> Void)? = nil
    var itemStr : String?
    var actionStr : String?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        lblItem?.text = itemStr
        lblAction?.text = actionStr
        updateMainLabel(calculateMainGallons(sldrMain.value))
        updateAuxLabel(calculateAuxGallons(sldrAux.value))
    }
    
    open func setPayload(_ payload : RecordFuelQuantityPayload) {
        itemStr = payload.item
        actionStr = payload.action
        setFuelLevelCallback = payload.setFuelLevelCallback
        completionCallback = payload.completionCallback
    }
    
    func calculateMainGallons(_ tankLevel : Float) -> Float {
        return self.sldrMain.value * 19.2
    }
    
    func calculateAuxGallons(_ tankLevel : Float) -> Float {
        return self.sldrAux.value * 10.5
    }
    
    func updateMainLabel(_ mainAmount : Float){
        lblMain.text = String(format: "Main (19.2 US Gallons) : %.2f (%.0f%%)", mainAmount, sldrMain.value * 100)
    }
    
    func updateAuxLabel(_ auxAmount : Float) {
        lblAux.text = String(format: "Aux (10.5 US Gallons) : %.2f (%.0f%%)", auxAmount, sldrAux.value * 100)
    }
    
    @IBAction func mainSldrChange(_ mainSlider:UISlider) {
        updateMainLabel(calculateMainGallons(sldrMain.value))
    }
    
    @IBAction func auxSldrChange(_ auxSlider:UISlider){
        updateAuxLabel(calculateAuxGallons(sldrAux.value))
    }
    
    @IBAction func returnToList(_ sender : AnyObject) {
        if let setFuelLevelCallback = self.setFuelLevelCallback {
            setFuelLevelCallback(sldrMain.value, sldrAux.value)
        }
        
        self.dismiss(animated: true, completion: completionCallback)
    }    
}
