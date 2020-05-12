//
//  ChecklistCell.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 7/1/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

class ChecklistCell : UITableViewCell {
    @IBOutlet var lblChecklistName : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblChecklistName.text = nil
    }
}
