//
//  RecordWeatherConditionsViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/24/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class RecordWeatherConditionsViewController : NotepadViewController {
    @IBOutlet var sldrBarometer : UISlider?
    @IBOutlet var sldrWindDirection : UISlider?
    @IBOutlet var sldrWindSpeed : UISlider?
    @IBOutlet var sldrTemperature : UISlider?
    
    @IBOutlet var tbBarometer : UITextField?
    @IBOutlet var tbWindDirection : UITextField?
    @IBOutlet var tbWindSpeed : UITextField?
    @IBOutlet var tbTemperature : UITextField?
    
    @IBAction func barometerChanged(slider : UISlider) {
        tbBarometer?.text = String(format: "%.2f", slider.value)
    }
    
    @IBAction func windDirectionChanged(slider : UISlider){
        tbWindDirection?.text = String(format: "%.0f", slider.value)
    }
    
    @IBAction func windSpeedChanged(slider : UISlider) {
        tbWindSpeed?.text = String(format: "%.0f", slider.value)
    }
    
    @IBAction func temperatureChanged(slider : UISlider) {
        tbTemperature?.text = String(format: "%.0f", slider.value)
    }
    
    @IBAction func returnToList(sender : AnyObject) {
        if let setWeatherConditionsCallback = payload?.setWeatherConditionsCallback {
            var barometerReading = sldrBarometer?.value ?? 0
            var windDirection = String(format:"%.0f", sldrWindDirection!.value).toInt()
            var windSpeed = String(format:"%.0f", sldrWindSpeed!.value).toInt()
            var temperature = String(format:"%.0f", sldrTemperature!.value).toInt()
            
            setWeatherConditionsCallback(barometerReading: barometerReading, windDirection: windDirection!, windSpeed: windSpeed!, temperature: temperature!)
        }
        
        self.dismissViewControllerAnimated(true, completion: payload?.completionCallback)
    }
    
    private var payload : RecordWeatherConditionsPayload?
    
    public func setPayload(payload : RecordWeatherConditionsPayload) {
        self.payload = payload
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let payload = self.payload {
            sldrBarometer?.value = payload.barometerReading!
            barometerChanged(sldrBarometer!)
            sldrWindDirection?.value = Float(payload.windDirection!)
            windDirectionChanged(sldrWindDirection!)
            sldrWindSpeed?.value = Float(payload.windSpeed!)
            windSpeedChanged(sldrWindSpeed!)
            sldrTemperature?.value = Float(payload.temperature!)
            temperatureChanged(sldrTemperature!)
        }
    }
}
