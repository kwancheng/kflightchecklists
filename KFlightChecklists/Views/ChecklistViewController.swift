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
    
    private func executePreAction(checklistItem:ChecklistItem?, callback : (()->Void)?) {
        executeAction(checklistItem?.preAction, checklistItem, callback: callback)
    }
    
    private func executePostAction(checklistItem:ChecklistItem?, callback : (()->Void)?) {
        executeAction(checklistItem?.postAction, checklistItem, callback: callback)
    }
    
    internal func setFuelQuantityCallback( mainTankLevel : Float, auxTankLevel : Float) -> Void  {
        self.flightInfo.mainTankLevel = mainTankLevel
        self.flightInfo.auxTankLevel = auxTankLevel
    }

    func setHobbsMeterReading(isPreFlight : Bool, _ reading : Float ) {
        if(isPreFlight) {
            self.flightInfo.preFlightHobbsReading = reading
        } else {
            self.flightInfo.postFlightHobbsReading = reading
        }
    }
    
    private func executeAction(action: Action?, _ checklistItem : ChecklistItem?, callback : (() -> Void)?) {
        if let action = action {
            var payload : Payload?
            var checklistItemAction = (item:checklistItem?.details?[0], action:checklistItem?.details?[1])
            
            if let sma = action as? ShowMessageAction {
                payload = sma.makePayload(
                    checklistItemAction.item,
                    checklistItemAction.action, callback)
            } else if let rfqa = action as? RecordFuelQuantityAction {
                payload = rfqa.makePayload(
                    checklistItemAction.item,
                    checklistItemAction.action,
                    setFuelLevelCallback: self.setFuelQuantityCallback,
                    completionCallback: callback)
            } else if let rhmra = action as? RecordHobbsMeterReadingAction {
                payload = rhmra.makePayload(
                    checklistItemAction.item,
                    checklistItemAction.action,
                    flightInfo.preFlightHobbsReading,
                    flightInfo.postFlightHobbsReading,
                    setHobbsMeterReadingCallback: self.setHobbsMeterReading,
                    completionCallback: callback)
            } else if let sfta = action as? StartFlightTimerAction {
            } else if let sfta = action as? StopFlightTimerAction {
                
            } else if let sta = action as? ShowTimerAction {
                
            } else if let rwca = action as? RecordWeatherConditionAction {
                
            }
            
            action.execute(self, payload)
        } else {
            // no action, just callback
            if let callback = callback {
                callback()
            }
        }
    }
        
    private func getChecklistItemAt(indexPath: NSIndexPath?) -> ChecklistItem? {
        return (indexPath == nil) ? nil : self.checklist?.sections?[indexPath!.section].checklistItems?[indexPath!.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // NOTE: sender is actually payload
        if let fuelQuantityVC = segue.destinationViewController as? R22FuelTankQuantityViewController {
            fuelQuantityVC.setPayload(sender as! RecordFuelQuantityPayload)
        } else if let flightInfoVC = segue.destinationViewController as? FlightInfoViewController {
            flightInfoVC.flightInfo = self.flightInfo
        } else if let recordHobbsVC = segue.destinationViewController as? HobbsReadingViewController {
            recordHobbsVC.setPayload(sender as! RecordHobbsMeterReadingPayload)
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
                var checklistItem = getChecklistItemAt(next)
                executePreAction(checklistItem, callback: navigationClosure)
            case .S1 :
                var checklistItem  = getChecklistItemAt(currentIndexPath)
                executePostAction(checklistItem, callback: navigationClosure)
            case .S2 :
                navigationClosure()
            case .S3 :
                var currentChecklistItem = getChecklistItemAt(currentIndexPath)
                executePostAction(currentChecklistItem, callback: { () -> Void in
                    var nextChecklistItem = self.getChecklistItemAt(next)
                    self.executePreAction(nextChecklistItem, callback: navigationClosure)
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