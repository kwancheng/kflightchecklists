//
//  FlightInfoViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class FlightInfoViewController : NotepadViewController {
    @IBOutlet var lblManifoldLimit : UILabel?

    @IBOutlet var viewFuelLevels : UIView?
    @IBOutlet var lblMainTankLevel : UILabel?
    @IBOutlet var lblAuxTankLevel : UILabel?
    @IBOutlet var pgsMainTankLevel : UIProgressView?
    @IBOutlet var pgsAuxTankLevel : UIProgressView?
    @IBOutlet var tbApproximateFlightTime : UITextField?

    @IBOutlet var viewHobbsMeter : UIView?
    @IBOutlet var tbPreFlightHobbsReading : UITextField?
    @IBOutlet var tbPostFlightHobbsReading : UITextField?
    @IBOutlet var tbHobbsUsed : UITextField?
    
    @IBOutlet var viewWeather : UIView?
    @IBOutlet var tbBarometerReading : UITextField?
    @IBOutlet var tbTemperature : UITextField?
    @IBOutlet var tbWindDirection : UITextField?
    @IBOutlet var tbWindSpeed : UITextField?
    @IBOutlet var tbWindGust : UITextField?
    
    @IBOutlet var viewFlightTime : UIView?
    @IBOutlet var tbFlightStart : UITextField?
    @IBOutlet var tbFlightEnd : UITextField?
    @IBOutlet var tbFlightDuration: UITextField?
    
    @IBOutlet var viewMapLimit : UIView?
    @IBOutlet var tbOat : UITextField?
    @IBOutlet var tbMapLimit : UITextField?
    @IBOutlet var tbTakeoff : UITextField?
    @IBOutlet var tbVne : UITextField?
    
    @IBAction func showMapVne(_ sender : AnyObject) {
        performSegue(withIdentifier: "ShowMapVneCharts", sender: self)
    }
    
    var flightInfo : FlightInfo?
    fileprivate let manifoldLimitCalculator  = ManifoldLimiteCalculator()
    fileprivate let vneLimitCalculator = VneLimitCalculator()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTankLevels()
        self.updateApproximateFlightTime()
        self.updateHobbsReadings()
        self.updateWeatherConditions()
        self.updateFlightTimes()
        self.updateManifoldPressure()
        
        viewFuelLevels?.layer.cornerRadius = 10
        viewFuelLevels?.layer.masksToBounds = true
        
        viewHobbsMeter?.layer.cornerRadius = 10
        viewHobbsMeter?.layer.masksToBounds = true
        
        viewWeather?.layer.cornerRadius = 10
        viewWeather?.layer.masksToBounds = true
        
        viewFlightTime?.layer.cornerRadius = 10
        viewFlightTime?.layer.masksToBounds = true
        
        viewMapLimit?.layer.cornerRadius = 10
        viewMapLimit?.layer.masksToBounds = true
    }
    
    fileprivate func updateManifoldPressure() {
        tbOat?.text = "Need Temp"
        tbMapLimit?.text = ""
        tbTakeoff?.text = ""
        tbVne?.text = ""
        if let temp = self.flightInfo?.temperature {
            tbOat?.text = String(format:"%.2f", temp)
            
            if let limit = manifoldLimitCalculator.calcMapLimit(0, oat: temp) {
                tbMapLimit?.text = String(format:"%.2f", limit)
                tbTakeoff?.text = String(format:"%.2f", limit + 0.9)
                
                if let vneLimit = vneLimitCalculator.calculateVne(0, oat: temp) {
                    tbVne?.text = String(format:"%.2f", vneLimit)
                }
            }
        }
    }
    
    fileprivate func updateTankLevels() {
        lblMainTankLevel?.text = String(format: "%.2f Gal (%.0f%%)", self.flightInfo!.calcActualMainLevel(), self.flightInfo!.mainTankLevel*100)
        lblAuxTankLevel?.text = String(format: "%.2f Gal (%.0f%%)", self.flightInfo!.calcActualAuxLevel(), self.flightInfo!.auxTankLevel*100)
        pgsMainTankLevel?.progress = self.flightInfo!.mainTankLevel
        pgsAuxTankLevel?.progress = self.flightInfo!.auxTankLevel
    }
    
    fileprivate func updateApproximateFlightTime() {
        tbApproximateFlightTime?.text = String(format: "%.0f Minutes", self.flightInfo!.calcApproximateFlightTime() * 60)
    }
    
    fileprivate func updateHobbsReadings() {
        tbPreFlightHobbsReading?.text = String(format: "%.1f", self.flightInfo!.preFlightHobbsReading)
        tbPostFlightHobbsReading?.text = String(format: "%.1f", self.flightInfo!.postFlightHobbsReading)
        
        let hobbsUsed = self.flightInfo!.postFlightHobbsReading - self.flightInfo!.preFlightHobbsReading

        tbHobbsUsed?.text = String(format: "%.1f", hobbsUsed)

    }

    fileprivate func updateWeatherConditions() {

        tbBarometerReading?.text = String(format:"%.2f", self.flightInfo!.barometerReading)

        tbTemperature?.text = String(format:"%d C", self.flightInfo!.temperature)

        

        tbWindDirection?.text = String(format:"%d", self.flightInfo!.windDirection)

        tbWindSpeed?.text = String(format:"%d", self.flightInfo!.windSpeed)

    }

    fileprivate func updateFlightTimes() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" // superset of OP's format

        

        var flightStartTimeStr = "None Recorded"

        if let flightStartTime = self.flightInfo?.flightStartTime {

            flightStartTimeStr = dateFormatter.string(from: flightStartTime as Date)

        }

        tbFlightStart?.text = flightStartTimeStr

        

        var flightEndTimeStr = "None Recorded"

        if let flightEndTime = self.flightInfo?.flightEndTime {

            flightEndTimeStr = dateFormatter.string(from: flightEndTime as Date)

        }

        tbFlightEnd?.text = flightEndTimeStr

        

        var durationStr = "--:--"

        if let flightStartTime = self.flightInfo?.flightStartTime {

            if let flightEndTime = self.flightInfo?.flightEndTime {

                let duration = flightEndTime.timeIntervalSince(flightStartTime as Date)
                let interval = Int(duration)
                let seconds = interval % 60
                let minutes = (interval/60)%60
                let hours =   (interval / 3600)
                durationStr = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            }
        }
        tbFlightDuration?.text = durationStr
    }
}
