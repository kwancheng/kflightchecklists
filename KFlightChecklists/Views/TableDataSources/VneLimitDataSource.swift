//
//  VneLimitDataSource.swift
//  KFlightChecklists
//
//  Created by Congee on 6/30/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class VneLimitDataSource : NSObject, UITableViewDataSource {
    fileprivate let vneLimitCalculator = VneLimitCalculator()
    open var oat : Int?
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oat == nil ? 0 : 8
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VneLimitCell

        

        let altitude = indexPath.row * 2000

        let vneLimit = self.vneLimitCalculator.calculateVne(altitude, oat: oat!)
        
        cell.lblAltitude?.text = altitude.description
        if vneLimit != -1 {
            cell.lblVne?.text = String(format:"%.2f", vneLimit!)
        } else {
            cell.lblVne?.text = "No Flight"
        }
        
        return cell
    }
}
