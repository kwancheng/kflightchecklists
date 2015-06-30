//
//  VneLimitDataSource.swift
//  KFlightChecklists
//
//  Created by Congee on 6/30/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class VneLimitDataSource : NSObject, UITableViewDataSource {
    private let vneCalculator = VNECalculator()
    public var oat : Int?
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oat == nil ? 0 : 8
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! VneLimitCell
        
        var altitude = indexPath.row * 2000
        var vneLimit = self.vneCalculator.calculateVne(altitude, oat: oat!)
        
        cell.lblAltitude?.text = altitude.description
        if vneLimit != -1 {
            cell.lblVne?.text = String(format:"%.2f", vneLimit!)
        } else {
            cell.lblVne?.text = "No Flight"
        }
        
        return cell
    }
}