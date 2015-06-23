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
    
    var flightInfo : FlightInfo?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTankLevels()
        self.updateApproximateFlightTime()
        self.updateHobbsReadings()
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
}
