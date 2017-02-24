//
//  RecordWeatherConditionsViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/24/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class RecordWeatherConditionsViewController : NotepadViewController {
    @IBOutlet var sldrBarometer : UISlider?
    @IBOutlet var sldrWindDirection : UISlider?
    @IBOutlet var sldrWindSpeed : UISlider?
    @IBOutlet var sldrTemperature : UISlider?
    
    @IBOutlet var tbBarometer : UITextField?
    @IBOutlet var tbWindDirection : UITextField?
    @IBOutlet var tbWindSpeed : UITextField?
    @IBOutlet var tbTemperature : UITextField?
    
    @IBAction func barometerChanged(_ slider : UISlider) {
        tbBarometer?.text = String(format: "%.2f", slider.value)
    }
    
    @IBAction func windDirectionChanged(_ slider : UISlider){
        tbWindDirection?.text = String(format: "%.0f", slider.value)
    }
    
    @IBAction func windSpeedChanged(_ slider : UISlider) {
        tbWindSpeed?.text = String(format: "%.0f", slider.value)
    }
    
    @IBAction func temperatureChanged(_ slider : UISlider) {
        tbTemperature?.text = String(format: "%.0f", slider.value)
    }
    
    @IBAction func returnToList(_ sender : AnyObject) {
        if let setWeatherConditionsCallback = payload?.setWeatherConditionsCallback {
            let barometerReading = sldrBarometer?.value ?? 0

            let windDirection = Int(String(format:"%.0f", sldrWindDirection!.value))

            let windSpeed = Int(String(format:"%.0f", sldrWindSpeed!.value))

            let temperature = Int(String(format:"%.0f", sldrTemperature!.value))
            
            setWeatherConditionsCallback(barometerReading, windDirection!, windSpeed!, temperature!)
        }
        
        self.dismiss(animated: true, completion: payload?.completionCallback)
    }
    
    @IBAction func getMetar(_ sender : AnyObject) {
        WeatherService.sharedService.getMetar("KLDJ",
            success: { (metarEntry) -> () in
                if(metarEntry != nil) {
                    self.sldrBarometer?.value = Float(metarEntry!.altimHg)
                    self.barometerChanged(self.sldrBarometer!)
                    self.sldrWindDirection?.value = Float(metarEntry!.windDirDegrees)
                    self.windDirectionChanged(self.sldrWindDirection!)
                    self.sldrWindSpeed?.value = Float(metarEntry!.windSpdKts)
                    self.windSpeedChanged(self.sldrWindSpeed!)
                    self.sldrTemperature?.value = Float(metarEntry!.tempC)
                    self.temperatureChanged(self.sldrTemperature!)
                }
            }) { (error) -> () in
                
            }
    }
    
    fileprivate var payload : RecordWeatherConditionsPayload?
    
    open func setPayload(_ payload : RecordWeatherConditionsPayload) {
        self.payload = payload
    }
    
    open override func viewDidLoad() {
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
