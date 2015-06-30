//
//  MapVneViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/29/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class MapVneViewController : UIViewController {
    @IBOutlet var tbOat : UITextField?
    @IBOutlet var sldrOat : UISlider?
    @IBOutlet var mapTable : UITableView?
    @IBOutlet var vneTable : UITableView?
    
    private var manifoldLimitDataSource = ManifoldLimitDataSource()
    private var vneLimitDataSource = VneLimitDataSource()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        mapTable?.dataSource = self.manifoldLimitDataSource
        manifoldLimitDataSource.oat = 10
        vneTable?.dataSource = self.vneLimitDataSource
        vneLimitDataSource.oat = 10
    }
    
    @IBAction func oatChanged(oatSlider : UISlider) {
        tbOat?.text = String(format:"%.0f", oatSlider.value)
        manifoldLimitDataSource.oat = Int(oatSlider.value)
        mapTable?.reloadData()
        vneLimitDataSource.oat = Int(oatSlider.value)
        vneTable?.reloadData()
    }
}