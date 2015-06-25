//
//  ChecklistViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

class ChecklistViewController : ViewController, UITableViewDataSource, UITableViewDelegate, ActionDelegate {
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
    
    private func executePreAction(checklistItem:ChecklistItem?, completionCallback : CompletionCallback?) {
        executeAction(checklistItem?.preAction, checklistItem: checklistItem, completionCallback: completionCallback)
    }
    
    private func executePostAction(checklistItem:ChecklistItem?, completionCallback : (()->Void)?) {
        executeAction(checklistItem?.postAction,checklistItem: checklistItem, completionCallback: completionCallback)
    }
    
    private func executeAction(action : Action?, checklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {
        if let action = action {
            action.actionDelegate = self
            action.execute(checklistItem, completionCallback: completionCallback)
        } else {
            if let completionCallback = completionCallback {
                completionCallback()
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
        } else if let rwcVC = segue.destinationViewController as? RecordWeatherConditionsViewController {
            rwcVC.setPayload(sender as! RecordWeatherConditionsPayload)
        }
    }
        
    enum ListItemTransition {
        case SOL  // Start of List
        case DOL  // Dual Wield
        case NAV  // Navigation
        
        static func getTransition(current : NSIndexPath?, _ next : NSIndexPath) -> ListItemTransition {
            var retVal = ListItemTransition.SOL
            if let current = current {
                if current.isEqual(next) {
                    retVal = ListItemTransition.DOL
                } else {
                    retVal = ListItemTransition.NAV
                }
            }
            return retVal
        }
    }
    
    enum ListItemState : Int {
        case START = 0,
        S0 = 1, // Execute Next PreAction Only
        S1 = 2, // Execute Current PostAction Only
        S2 = 3, // Just Navigate
        S3 = 4, // Execute Current PostAction, Then Next PreAction
        ERROR = 5
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
                executePreAction(checklistItem, completionCallback: navigationClosure)
            case .S1 :
                var checklistItem  = getChecklistItemAt(currentIndexPath)
                executePostAction(checklistItem, completionCallback: navigationClosure)
            case .S2 :
                navigationClosure()
            case .S3 :
                var currentChecklistItem = getChecklistItemAt(currentIndexPath)
                executePostAction(currentChecklistItem, completionCallback: { () -> Void in
                    var nextChecklistItem = self.getChecklistItemAt(next)
                    self.executePreAction(nextChecklistItem, completionCallback: navigationClosure)
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
    
    // MARK : ActionDelegate
    func showMessage(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {
        if let showMessageAction = action as? ShowMessageAction {
            let alertController = UIAlertController(title: nil, message: showMessageAction.message, preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                if let callback = completionCallback {
                    callback()
                }
            })
            alertController.addAction(defaultAction)
            
            dispatch_async(dispatch_get_main_queue(), {()->Void in
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        } else {
            if let completionCallback = completionCallback {
                completionCallback()
            }
        }
    }
    
    func recordFuelQuantity(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    {
        var payload = RecordFuelQuantityPayload(
            onChecklistItem?.details?[0],
            onChecklistItem?.details?[1],
            self.flightInfo.setFuelQuantityCallback,
            completionCallback)
        
        dispatch_async(dispatch_get_main_queue(), {()->Void in
            self.performSegueWithIdentifier("ShowFuelQuantityNotepad", sender: payload)
        })
    }
    
    func recordHobbsMeterReading(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    {
        if let recordHobbsMeterReadingAction = action as? RecordHobbsMeterReadingAction {
            var reading = (recordHobbsMeterReadingAction.isPreFlight ?? false) ? flightInfo.preFlightHobbsReading : flightInfo.postFlightHobbsReading
            
            var payload = RecordHobbsMeterReadingPayload(
                onChecklistItem?.details?[0],
                onChecklistItem?.details?[1],
                recordHobbsMeterReadingAction.isPreFlight,
                reading,
                flightInfo.setHobbsMeterReading,
                completionCallback)
    
            dispatch_async(dispatch_get_main_queue(), {()->Void in
                self.performSegueWithIdentifier("ShowHobbsReadingNotepad", sender: payload)
            })
        } else {
            if let completionCallback = completionCallback {
                completionCallback()
            }
        }
        
    }
    func recordWeatherCondition(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    {
        if let rwca = action as? RecordWeatherConditionsAction {
            var payload = RecordWeatherConditionsPayload(
                barometerReading: flightInfo.barometerReading,
                windDirection: flightInfo.windDirection,
                windSpeed: flightInfo.windSpeed,
                temperature: flightInfo.temperature,
                item: onChecklistItem!.details![0],
                action: onChecklistItem!.details![1],
                setWeatherConditionsCallback: flightInfo.setWeatherConditions,
                completionCallback: completionCallback)
            
            dispatch_async(dispatch_get_main_queue(), {()->Void in
                self.performSegueWithIdentifier("ShowRecordWeatherNotepad", sender: payload)
            })
        } else {
            if let completionCallback = completionCallback {
                completionCallback()
            }
        }
    }
    func startFlightTimer(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {
        self.flightInfo.flightStartTime = NSDate()
        
        let alertController = UIAlertController(title: nil, message: "Flight Timer Started", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            if let callback = completionCallback {
                callback()
            }
        })
        alertController.addAction(defaultAction)
        
        dispatch_async(dispatch_get_main_queue(), {()->Void in
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    func stopFlightTimer(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {
        self.flightInfo.flightEndTime = NSDate()
        let alertController = UIAlertController(title: nil, message: "Flight Timer Ended", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            if let callback = completionCallback {
                callback()
            }
        })
        alertController.addAction(defaultAction)
        
        dispatch_async(dispatch_get_main_queue(), {()->Void in
            self.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }
    func showTimer(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {
        
    }
}