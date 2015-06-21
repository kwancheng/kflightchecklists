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
    
    var flightInfo : FlightInfo?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTankLevels()
        self.updateApproximateFlightTime()
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
}
