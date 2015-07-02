//
//  ManifoldLimiteDataSource.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/29/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class ManifoldLimitDataSource : NSObject, UITableViewDataSource {
    private let manifoldLimitCalculator = ManifoldLimiteCalculator()
    public var oat : Int?
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oat == nil ? 0 : 5
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ManifoldLimitCell
        
        var altitude = indexPath.row * 2000
        var mapLimit = manifoldLimitCalculator.calcMapLimit(altitude, oat: oat!)
        
        cell.lblAltitude?.text = altitude.description
        if mapLimit != -1 {
            var maxTakeoff = mapLimit! + 0.9
            cell.lblMapLimit?.text = String(format:"%.2f - %.2f", mapLimit!, maxTakeoff)
        } else {
            cell.lblMapLimit?.text = "Full Throttle"
        }
        
        return cell
    }
}