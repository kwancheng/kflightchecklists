//
//  ManifoldLimitCell.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/29/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

class ManifoldLimitCell : UITableViewCell {
    @IBOutlet var lblAltitude : UILabel!
    @IBOutlet var lblMapLimit : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lblAltitude.text = nil
        lblMapLimit.text = nil
    }
}
