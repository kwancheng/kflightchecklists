//
//  NotepadViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 7/1/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class NotepadViewController : UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "notepad_background")!)
    }
}
