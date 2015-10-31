//
//  ChecklistSelectViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

class ChecklistSelectViewController : ViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var lbChecklists : UITableView?
    
    private var selectedChecklist : Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbChecklists?.dataSource = self
        lbChecklists?.delegate = self
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "main_background")!)
        lbChecklists?.backgroundColor = UIColor.clearColor()
    }
    
    // MARK : UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let tCount = self.checklistPack.checklists?.count {
            count = tCount
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ChecklistCell
        
        cell.lblChecklistName?.text = self.checklistPack.checklists?[indexPath.row].title
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    // MARK : UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedChecklist = self.checklistPack.checklists?[indexPath.row]
        performSegueWithIdentifier("PerformChecklist", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        let destVC = segue.destinationViewController as! ChecklistViewController
        destVC.setChecklist(selectedChecklist!)
    }
}
