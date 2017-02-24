//
//  LaunchScreen.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 7/2/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class LaunchScreen : UIView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor(patternImage: UIImage(named: "main_background")!)
    }
}
