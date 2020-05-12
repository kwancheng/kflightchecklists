//
//  ActionItemCell.swift
//  KFlightChecklists
//
//  Created by Congee on 6/14/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

class ActionItemCell : UITableViewCell {
    @IBOutlet var lblItem : UILabel!
    @IBOutlet var lblAction : UILabel!
    
    override func prepareForReuse() {
        lblItem.text = nil
        lblAction.text = nil
    }
}
