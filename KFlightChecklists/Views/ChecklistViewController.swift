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
    private var flightInfo = FlightInfo()
    
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
    
    private var currentIndexPath : NSIndexPath? = nil
    
    private func advanceIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        var retVal : NSIndexPath? = nil
        
        var section = indexPath.section
        var row = indexPath.row
        
        if let rowCount = self.checklist?.sections?[section].checklistItems?.count {
            if let sectionCount = self.checklist?.sections?.count {
                var endOfChecklist = false
                row++
                if(row >= rowCount) {
                    row = 0
                    section++
                    if(section >= sectionCount) {
                        endOfChecklist = true
                    }
                }
                
                // new index
                if(!endOfChecklist) {
                    retVal = NSIndexPath(forRow: row, inSection: section)
                }
            } // error state failsafe to no target
        } // error state failsafe to no target

        return retVal
    }
    
    private func executeAction(checklistItem : ChecklistItem?, _ actionType : ActionType, callback : () -> Void) {
        var action : Action?
        switch actionType {
            case .Pre :
                action = checklistItem?.preAction
            case .Post :
                action = checklistItem?.postAction
        }
        
        if let actionName = action?.type {
            switch actionName {
                case "ShowMessage" :
                    if let showMessageAction = action as? ShowMessageAction {
                        var alert = UIAlertController(title: nil, message: showMessageAction.message, preferredStyle: UIAlertControllerStyle.Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                            callback()
                        })
                        
                        alert.addAction(defaultAction)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.presentViewController(alert, animated: true, completion: nil)
                        })                        
                    }
                case "FuelQuantityNotepad" :
                    dispatch_async(dispatch_get_main_queue(), {()->Void in
                        var payload = ShowFuelQuantityNotepadPayload()
                        payload.itemStr = checklistItem?.details?[0]
                        payload.actionStr = checklistItem?.details?[1]
                        payload.setTankLevel = self.setFuelQuantity
                        payload.callback = callback
                        self.performSegueWithIdentifier("ShowFuelQuantityNotepad", sender: payload)
                    })
            case "HobbsNotepad" :
                    break
                default :
                    // unknown action just skip
                    callback()
            }
        } else {
            callback()
        }
    }
    
    func setFuelQuantity(mainTankLevel : Float , auxTankLevel : Float) {
        self.flightInfo.mainTankLevel = mainTankLevel
        self.flightInfo.auxTankLevel = auxTankLevel
    }
        
    private func getChecklistItemAt(indexPath: NSIndexPath?) -> ChecklistItem? {
        return (indexPath == nil) ? nil : self.checklist?.sections?[indexPath!.section].checklistItems?[indexPath!.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let fuelQuantityVC = segue.destinationViewController as? R22FuelTankQuantityViewController {
            if let payload = sender as? ShowFuelQuantityNotepadPayload {
                fuelQuantityVC.itemStr = payload.itemStr
                fuelQuantityVC.actionStr = payload.actionStr
                fuelQuantityVC.setTankLevelDelegate = payload.setTankLevel
                fuelQuantityVC.callback = payload.callback
            }
        } else if let flightInfoVC = segue.destinationViewController as? FlightInfoViewController {
            flightInfoVC.flightInfo = self.flightInfo
        }
    }
        
    private var supressNextPreAction = false
    private var supressCurrentPostAction = false
    
    enum ListItemTransition {
        case SOL  // Start of List
        case DOL  // Dual Wield
        case NAV  // Navigation
        
        static func getTransition(current : NSIndexPath?, _ next : NSIndexPath) -> ListItemTransition {
            if let current = current {
                if current.isEqual(next) {
                    return ListItemTransition.DOL
                } else {
                    return ListItemTransition.NAV
                }
            } else {
                return ListItemTransition.SOL
            }
        }
    }
    
    enum ListItemState : Int {
        case START = 0, S0 = 1, S1 = 2, S2 = 3, S3 = 4, ERROR = 5
    }
    
    private var currentState = ListItemState.START
    
    private let transitionTable : [ListItemTransition:[ListItemState]] = [
        .SOL : [.S0, .ERROR, .ERROR, .ERROR, .ERROR],
        .DOL : [.ERROR, .S1, .S2, .S2, .S1],
        .NAV : [.ERROR, .S3, .S0, .S0, .S3]
    ]
    
    private enum ActionType {
        case Pre, Post
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var next = indexPath
        if let currentIndexPath = self.currentIndexPath {
            if currentIndexPath.isEqual(indexPath) {
                next = advanceIndexPath(indexPath) ?? indexPath
            }
        }
        
        var transition = ListItemTransition.getTransition(currentIndexPath, next)
        
        let stateRows = transitionTable[transition]
        currentState = stateRows![currentState.rawValue]
        
        var navigationClosure = {() -> Void in
            tableView.selectRowAtIndexPath(next, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            self.currentIndexPath = next
        }
        
        switch currentState {
            case .START :
                break
            case .S0 :
                executeAction(getChecklistItemAt(next), ActionType.Pre, callback: navigationClosure)
            case .S1 :
                executeAction(getChecklistItemAt(currentIndexPath), ActionType.Post, callback: navigationClosure)
            case .S2 :
                navigationClosure()
            case .S3 :
                executeAction(getChecklistItemAt(currentIndexPath), ActionType.Post, callback: { () -> Void in
                    self.executeAction(self.getChecklistItemAt(next), ActionType.Pre, callback: navigationClosure)
                })
            case .ERROR :
                var alert = UIAlertController(title: nil, message: "Error Occurred Restarting", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                        self.currentState = .START
                        self.currentIndexPath = nil
                    }))
                presentViewController(alert, animated: true, completion: nil)
        }
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
    
    @IBAction func showFlightInfo(sender : AnyObject) {
        performSegueWithIdentifier("ShowFlightInfo", sender: self)
    }
}