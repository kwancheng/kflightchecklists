//
//  FlightInfoViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class FlightInfoViewController : UIViewController {
    @IBOutlet var lblMainTankLevel : UILabel?
    @IBOutlet var lblAuxTankLevel : UILabel?
    @IBOutlet var lblApproximateFlightTime : UILabel?
    @IBOutlet var pgsMainTankLevel : UIProgressView?
    @IBOutlet var pgsAuxTankLevel : UIProgressView?
    @IBOutlet var lblPreFlightHobbsReading : UILabel?
    @IBOutlet var lblPostFlightHobbsReading : UILabel?
    @IBOutlet var lblHobbsUsed : UILabel?
    @IBOutlet var lblBarometerReading : UILabel?
    @IBOutlet var lblWindConditions : UILabel?
    @IBOutlet var lblTemperature : UILabel?
    @IBOutlet var lblFlightTime : UILabel?
    @IBOutlet var lblManifoldLimit : UILabel?
    
    @IBAction func showMapVne(sender : AnyObject) {
        performSegueWithIdentifier("ShowMapVNE", sender: self)
    }
    
    var flightInfo : FlightInfo?
    private let manifoldLimitCalculator  = ManifoldLimiteCalculator()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTankLevels()
        self.updateApproximateFlightTime()
        self.updateHobbsReadings()
        self.updateWeatherConditions()
        self.updateFlightTimes()
        self.updateManifoldPressure()
    }
    
    private func updateManifoldPressure() {
        let formatTemplate = "Manifold Limit : Temp[%d C] @SL Limit[%.2f] Takeoff[%.2fs](5 min)"
        
        var msg = "Manifold Limit : No Temperature Recorded"
        if let temp = self.flightInfo?.temperature {
            if let limit = manifoldLimitCalculator.getManifoldPressureAtAltitude(0, oat: temp) {
                let max = limit + 0.9
                msg = String(format:formatTemplate, temp, limit, max )
            } else {
                msg = String(format:"Manifold Limit : Limit not found for Temp[%d]", temp)
            }
        }
        
        lblManifoldLimit?.text = msg
    }
    
    private func updateTankLevels() {
        lblMainTankLevel?.text = String(format: "%.2f Gal (%.0f%%)", self.flightInfo!.calcActualMainLevel(), self.flightInfo!.mainTankLevel*100)
        lblAuxTankLevel?.text = String(format: "%.2f Gal (%.0f%%)", self.flightInfo!.calcActualAuxLevel(), self.flightInfo!.auxTankLevel*100)
        pgsMainTankLevel?.progress = self.flightInfo!.mainTankLevel
        pgsAuxTankLevel?.progress = self.flightInfo!.auxTankLevel
    }
    
    private func updateApproximateFlightTime() {
        lblApproximateFlightTime?.text = String(format: "Approximate Flight Time : %.0f Minutes", self.flightInfo!.calcApproximateFlightTime() * 60)
    }
    
    private func updateHobbsReadings() {
        lblPreFlightHobbsReading?.text = String(format: "Pre-Flight Hobbs Reading : %.1f", self.flightInfo!.preFlightHobbsReading)
        lblPostFlightHobbsReading?.text = String(format: "Post-Flight Hobbs Reading : %.1f", self.flightInfo!.postFlightHobbsReading)
        
        var hobbsUsed = self.flightInfo!.postFlightHobbsReading - self.flightInfo!.preFlightHobbsReading
        lblHobbsUsed?.text = String(format: "Total Hobbs Used : %.1f", hobbsUsed)
    }
    
    private func updateWeatherConditions() {
        lblBarometerReading?.text = String(format:"Barometer Reading : %.2f", self.flightInfo!.barometerReading)
        lblWindConditions?.text = String(format:"Wind Direction and Speed : %d (%d)", self.flightInfo!.windDirection, self.flightInfo!.windSpeed)
        lblTemperature?.text = String(format:"Temperature : %d C", self.flightInfo!.temperature)
    }
    
    private func updateFlightTimes() {
        let formatTemplate = "Flight Time : Start[%@] End[%@] Duration[%@]"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" // superset of OP's format
        
        var flightStartTimeStr = "None Recorded"
        if let flightStartTime = self.flightInfo?.flightStartTime {
            flightStartTimeStr = dateFormatter.stringFromDate(flightStartTime)
        }
        
        var flightEndTimeStr = "None Recorded"
        if let flightEndTime = self.flightInfo?.flightEndTime {
            flightEndTimeStr = dateFormatter.stringFromDate(flightEndTime)
        }
        
        var durationStr = "--:--"
        if let flightStartTime = self.flightInfo?.flightStartTime {
            if let flightEndTime = self.flightInfo?.flightEndTime {
                var duration = flightEndTime.timeIntervalSinceDate(flightStartTime)
                let interval = Int(duration)
                let seconds = interval % 60
                let minutes = (interval/60)%60
                let hours =   (interval / 3600)
                durationStr = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            }
        }
        
        lblFlightTime?.text = String(format: formatTemplate, flightStartTimeStr, flightEndTimeStr, durationStr)        
    }
}
