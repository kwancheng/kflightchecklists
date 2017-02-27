//
//  MapVneViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/29/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class MapVneViewController : NotepadViewController {
    @IBOutlet var tbOat : UITextField!
    @IBOutlet var sldrOat : UISlider!
    @IBOutlet var mapTable : UITableView!
    @IBOutlet var vneTable : UITableView!
    
    fileprivate var manifoldLimitDataSource = ManifoldLimitDataSource()
    fileprivate var vneLimitDataSource = VneLimitDataSource()
    fileprivate var payload : ShowMapVNEChartsPayload?
    
    fileprivate var completionCallback : CompletionCallback?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        mapTable.dataSource = self.manifoldLimitDataSource
        manifoldLimitDataSource.oat = 10
        vneTable.dataSource = self.vneLimitDataSource
        vneLimitDataSource.oat = 10
        
        if let payload = payload {
            sldrOat.setValue(payload.oat, animated: true)
        }
        oatChanged(sldrOat)
    }
    
    open func setPayload(_ payload : ShowMapVNEChartsPayload){
        self.payload = payload
        self.completionCallback = payload.completionCallback
    }
    
    @IBAction func oatChanged(_ oatSlider : UISlider) {
        let oat = Int(oatSlider.value)
        tbOat?.text = oat.description
        
        manifoldLimitDataSource.oat = oat
        mapTable?.reloadData()
        vneLimitDataSource.oat = oat
        vneTable?.reloadData()
    }
    
    @IBAction func hideVneMapCharts(_ button : UIButton) {
        self.dismiss(animated: true, completion: completionCallback)
    }
}
