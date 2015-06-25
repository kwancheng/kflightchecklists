//
//  R22FuelTankQuantityViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/16/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class R22FuelTankQuantityViewController : UIViewController {
    @IBOutlet private var lblMain : UILabel?
    @IBOutlet private var sldrMain : UISlider?
    @IBOutlet private var lblAux : UILabel?
    @IBOutlet private var sldrAux : UISlider?
    @IBOutlet var lblItem : UILabel?
    @IBOutlet var lblAction : UILabel?
    
    var completionCallback : (()->Void)? = nil
    var setFuelLevelCallback : ((mainGallons:Float, auxGallons:Float) -> Void)? = nil
    var itemStr : String?
    var actionStr : String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        lblItem?.text = itemStr
        lblAction?.text = actionStr
        updateMainLabel(calculateMainGallons(sldrMain!.value))
        updateAuxLabel(calculateAuxGallons(sldrAux!.value))
    }
    
    public func setPayload(payload : RecordFuelQuantityPayload) {
        itemStr = payload.item
        actionStr = payload.action
        setFuelLevelCallback = payload.setFuelLevelCallback
        completionCallback = payload.completionCallback
    }
    
    func calculateMainGallons(tankLevel : Float) -> Float {
        return self.sldrMain!.value * 19.2
    }
    
    func calculateAuxGallons(tankLevel : Float) -> Float {
        return self.sldrAux!.value * 10.5
    }
    
    func updateMainLabel(mainAmount : Float){
        lblMain?.text = String(format: "Main (19.2 US Gallons) : %.2f (%.0f%%)", mainAmount, sldrMain!.value * 100)
    }
    
    func updateAuxLabel(auxAmount : Float) {
        lblAux?.text = String(format: "Aux (10.5 US Gallons) : %.2f (%.0f%%)", auxAmount, sldrAux!.value * 100)
    }
    
    @IBAction func mainSldrChange(mainSlider:UISlider) {
        updateMainLabel(calculateMainGallons(sldrMain!.value))
    }
    
    @IBAction func auxSldrChange(auxSlider:UISlider){
        updateAuxLabel(calculateAuxGallons(sldrAux!.value))
    }
    
    @IBAction func returnToList(sender : AnyObject) {
        if let setFuelLevelCallback = self.setFuelLevelCallback {
            setFuelLevelCallback(mainGallons: sldrMain!.value, auxGallons: sldrAux!.value)
        }
        
        self.dismissViewControllerAnimated(true, completion: completionCallback)
    }    
}
