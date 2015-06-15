//
//  ChecklistViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

class ChecklistViewController : ViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var navItem : UINavigationItem?
    @IBOutlet var lbChecklist : UITableView?
    
    private var checklist : Checklist?
    private var sectionHeaders : [UIView]?
    
    func setChecklist(var checklist : Checklist) {
        self.checklist = checklist
    }
    
    override func viewDidLoad() {
        navItem?.title = self.checklist?.title
     
        self.lbChecklist?.rowHeight = UITableViewAutomaticDimension
        self.lbChecklist?.estimatedRowHeight = 44.0
        self.lbChecklist?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
                
        self.lbChecklist?.dataSource = self
        self.lbChecklist?.delegate = self
    }
    
    // MARK : UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = 0
        if let newCount = self.checklist?.sections?.count {
            count = newCount
        }
        return count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let newCount = self.checklist?.sections?[section].checklistItems?.count {
            count = newCount
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var retCell : UITableViewCell? = nil
        
        if let checklistItem = self.checklist?.sections?[indexPath.section].checklistItems?[indexPath.row] {
            if let type = checklistItem.type {
                switch type {
                case .ActionItem :
                    var cell = tableView.dequeueReusableCellWithIdentifier("ActionItemCell") as! ActionItemCell
                    cell.lblItem?.text = checklistItem.details?[0]
                    cell.lblAction?.text = checklistItem.details?[1]
                    retCell = cell
                case .Note :
                    var cell = tableView.dequeueReusableCellWithIdentifier("NoteCell") as! NoteCell
                    cell.lblNoteText?.text = checklistItem.details?[0]
                    retCell = cell
                case .Caution :
                    var cell = tableView.dequeueReusableCellWithIdentifier("CautionCell") as! CautionCell
                    cell.lblCautionText?.text = checklistItem.details?[0]
                    retCell = cell
                }
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
                cell.textLabel?.text = "Unknown"
                retCell = cell
            }
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            cell.textLabel?.text = "Unknown"
            retCell = cell
        }
        
        var bgView = UIView()
        bgView.backgroundColor = UIColor.greenColor()
        retCell?.selectedBackgroundView = bgView
        
        return retCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(String(format: "Selected Section[%d] Row[%d]",indexPath.section, indexPath.row))
    }
    
    // MARK : UITableViewDelegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var ret : SectionHeader? = nil
    
        if let sectionHeader = NSBundle.mainBundle().loadNibNamed("SectionHeader", owner: self, options: nil)[0] as? SectionHeader {
            sectionHeader.lblTitle?.text = checklist?.sections?[section].title
            
            ret = sectionHeader
        }
        
        return ret
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 43
    }
}