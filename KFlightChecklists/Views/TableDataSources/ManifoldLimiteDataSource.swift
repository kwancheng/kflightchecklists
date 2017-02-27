//
//  ManifoldLimiteDataSource.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/29/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class ManifoldLimitDataSource : NSObject, UITableViewDataSource {
    fileprivate let manifoldLimitCalculator = ManifoldLimiteCalculator()
    open var oat : Int?
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oat == nil ? 0 : 5
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ManifoldLimitCell

        

        let altitude = indexPath.row * 2000

        let mapLimit = manifoldLimitCalculator.calcMapLimit(altitude, oat: oat!)

        

        cell.lblAltitude?.text = altitude.description

        if mapLimit != -1 {

            let maxTakeoff = mapLimit! + 0.9
            cell.lblMapLimit?.text = String(format:"%.2f - %.2f", mapLimit!, maxTakeoff)
        } else {
            cell.lblMapLimit?.text = "Full Throttle"
        }
        
        return cell
    }
}
