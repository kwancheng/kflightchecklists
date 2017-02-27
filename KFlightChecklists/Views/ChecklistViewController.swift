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
    @IBOutlet var tbFlightTime : UITextField?
    @IBOutlet var btnToggleTimeShown : UIButton?
    
    fileprivate var checklist : Checklist?
    fileprivate var sectionHeaders : [UIView]?
    fileprivate var flightInfo = FlightInfo()
    
    func setChecklist(_ checklist : Checklist) {

        self.checklist = checklist

    }

    

    override func viewDidLoad() {

        navItem?.title = self.checklist?.title

     

        self.lbChecklist?.rowHeight = UITableViewAutomaticDimension

        self.lbChecklist?.estimatedRowHeight = 44.0

        self.lbChecklist?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

                

        self.lbChecklist?.dataSource = self

        self.lbChecklist?.delegate = self

        

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "checklist_background")!)

        lbChecklist?.backgroundColor = UIColor.clear

    }

    

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        

        let userDefaults = UserDefaults.standard

        guard let _ = userDefaults.string(forKey: "agreed") else {
            performSegue(withIdentifier: "ShowAgreement", sender: self)
            return
        }
    }

    

    // MARK : UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        var count = 0

        if let newCount = self.checklist?.sections?.count {

            count = newCount

        }

        return count

    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var count = 0

        if let newCount = self.checklist?.sections?[section].checklistItems?.count {

            count = newCount

        }

        return count

    }

    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var retCell : UITableViewCell? = nil

        

        if let checklistItem = self.checklist?.sections?[indexPath.section].checklistItems?[indexPath.row] {

            if let type = checklistItem.type {

                switch type {

                    case .ActionItem :

                        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionItemCell") as! ActionItemCell

                        cell.lblItem?.text = checklistItem.details?[0]

                        cell.lblAction?.text = checklistItem.details?[1]

                        retCell = cell

                    case .Note :

                        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as! NoteCell

                        cell.lblNoteText?.text = checklistItem.details?[0]

                        retCell = cell

                    case .Caution :

                        let cell = tableView.dequeueReusableCell(withIdentifier: "CautionCell") as! CautionCell

                        cell.lblCautionText?.text = checklistItem.details?[0]

                        retCell = cell

                }

            } else {

                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell

                cell.textLabel?.text = "Unknown"

                retCell = cell

            }

        } else {

            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell

            cell.textLabel?.text = "Unknown"

            retCell = cell

        }

        let bgView = UIView()

        bgView.backgroundColor = UIColor(patternImage: UIImage(named: "main_background")!)

        bgView.layer.cornerRadius = 10

        bgView.layer.masksToBounds = true

        retCell?.selectedBackgroundView = bgView

        retCell?.backgroundColor = UIColor.clear

        

        return retCell!

    }

    

    fileprivate var currentIndexPath : IndexPath? = nil

    

    fileprivate func advanceIndexPath(_ indexPath: IndexPath) -> IndexPath? {

        var retVal : IndexPath? = nil

        

        var section = indexPath.section

        var row = indexPath.row

        

        if let rowCount = self.checklist?.sections?[section].checklistItems?.count {

            if let sectionCount = self.checklist?.sections?.count {

                var endOfChecklist = false

                row += 1

                if(row >= rowCount) {

                    row = 0

                    section += 1

                    if(section >= sectionCount) {

                        endOfChecklist = true

                    }

                }

                

                // new index

                if(!endOfChecklist) {

                    retVal = IndexPath(row: row, section: section)

                }

            } // error state failsafe to no target

        } // error state failsafe to no target



        return retVal

    }

    

    fileprivate func executePreAction(_ checklistItem:ChecklistItem?, completionCallback : CompletionCallback?) {

        executeAction(checklistItem?.preAction, checklistItem: checklistItem, completionCallback: completionCallback)

    }

    

    fileprivate func executePostAction(_ checklistItem:ChecklistItem?, completionCallback : (()->Void)?) {

        executeAction(checklistItem?.postAction,checklistItem: checklistItem, completionCallback: completionCallback)

    }

    

    fileprivate func executeAction(_ action : Action?, checklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {

        if let action = action {

            action.actionDelegate = self

            action.execute(checklistItem, completionCallback: completionCallback)

        } else {

            if let completionCallback = completionCallback {

                completionCallback()

            }

        }

    }

    

    fileprivate func getChecklistItemAt(_ indexPath: IndexPath?) -> ChecklistItem? {

        return (indexPath == nil) ? nil : self.checklist?.sections?[indexPath!.section].checklistItems?[indexPath!.row]

    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // NOTE: sender is actually payload

        if let fuelQuantityVC = segue.destination as? R22FuelTankQuantityViewController {

            fuelQuantityVC.setPayload(sender as! RecordFuelQuantityPayload)

        } else if let flightInfoVC = segue.destination as? FlightInfoViewController {

            flightInfoVC.flightInfo = self.flightInfo

        } else if let recordHobbsVC = segue.destination as? HobbsReadingViewController {

            recordHobbsVC.setPayload(sender as! RecordHobbsMeterReadingPayload)

        } else if let rwcVC = segue.destination as? RecordWeatherConditionsViewController {

            rwcVC.setPayload(sender as! RecordWeatherConditionsPayload)

        } else if let stVC = segue.destination as? TimerViewController {

            stVC.setPayload(sender as! ShowTimerPayload)

        } else if let smvVC = segue.destination as? MapVneViewController {

            smvVC.setPayload(sender as! ShowMapVNEChartsPayload)

        }

    }

        

    enum ListItemTransition {

        case sol  // Start of List

        case dol  // Dual Wield

        case nav  // Navigation

        

        static func getTransition(_ current : IndexPath?, _ next : IndexPath) -> ListItemTransition {

            var retVal = ListItemTransition.sol

            if let current = current {

                if current == next {

                    retVal = ListItemTransition.dol

                } else {

                    retVal = ListItemTransition.nav

                }

            }

            return retVal

        }

    }

    

    enum ListItemState : Int {

        case start = 0,

        s0 = 1, // Execute Next PreAction Only

        s1 = 2, // Execute Current PostAction Only

        s2 = 3, // Just Navigate

        s3 = 4, // Execute Current PostAction, Then Next PreAction

        error = 5

    }

    

    fileprivate var currentState = ListItemState.start

    

    fileprivate let transitionTable : [ListItemTransition:[ListItemState]] = [

        .sol : [.s0, .error, .error, .error, .error],

        .dol : [.error, .s1, .s2, .s2, .s1],

        .nav : [.error, .s3, .s0, .s0, .s3]

    ]

    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var next = indexPath

        if let currentIndexPath = self.currentIndexPath {

            if currentIndexPath == indexPath {

                next = advanceIndexPath(indexPath) ?? indexPath

            }

        }

        

        let transition = ListItemTransition.getTransition(currentIndexPath, next)

        

        let stateRows = transitionTable[transition]

        currentState = stateRows![currentState.rawValue]

        

        let navigationClosure = {() -> Void in

            tableView.selectRow(at: next, animated: true, scrollPosition: UITableViewScrollPosition.middle)

            self.currentIndexPath = next

        }

        

        switch currentState {

            case .start :

                break

            case .s0 :

                let checklistItem = getChecklistItemAt(next)

                executePreAction(checklistItem, completionCallback: navigationClosure)

            case .s1 :

                let checklistItem  = getChecklistItemAt(currentIndexPath)

                executePostAction(checklistItem, completionCallback: navigationClosure)

            case .s2 :

                navigationClosure()

            case .s3 :

                let currentChecklistItem = getChecklistItemAt(currentIndexPath)

                executePostAction(currentChecklistItem, completionCallback: { () -> Void in

                    let nextChecklistItem = self.getChecklistItemAt(next)

                    self.executePreAction(nextChecklistItem, completionCallback: navigationClosure)

                })

            case .error :

                let alert = UIAlertController(title: nil, message: "Error Occurred Restarting", preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in

                        self.currentState = .start

                        self.currentIndexPath = nil

                    }))

                present(alert, animated: true, completion: nil)

        }

    }

    

    // MARK : UITableViewDelegate

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var ret : SectionHeader? = nil

    

        if let sectionHeader = Bundle.main.loadNibNamed("SectionHeader", owner: self, options: nil)?[0] as? SectionHeader {

            sectionHeader.lblTitle?.text = checklist?.sections?[section].title

            ret = sectionHeader

        }

        

        return ret

    }

    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 43

    }    
    

    @IBAction func showFlightInfo(_ sender : AnyObject) {

        performSegue(withIdentifier: "ShowFlightInfo", sender: self)

    }

    

    // MARK : ActionDelegate

    func showMessage(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {

        if let showMessageAction = action as? ShowMessageAction {

            let alertController = UIAlertController(title: nil, message: showMessageAction.message, preferredStyle: UIAlertControllerStyle.alert)

            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in

                if let callback = completionCallback {

                    callback()

                }

            })

            alertController.addAction(defaultAction)

            

            DispatchQueue.main.async(execute: {()->Void in

                self.present(alertController, animated: true, completion: nil)

            })

        } else {

            if let completionCallback = completionCallback {

                completionCallback()

            }

        }

    }

    

    func recordFuelQuantity(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)

    {

        let payload = RecordFuelQuantityPayload(

            onChecklistItem?.details?[0],

            onChecklistItem?.details?[1],

            self.flightInfo.setFuelQuantityCallback,

            completionCallback)

        

        DispatchQueue.main.async(execute: {()->Void in

            self.performSegue(withIdentifier: "ShowFuelQuantityNotepad", sender: payload)

        })

    }

    

    func recordHobbsMeterReading(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)

    {

        if let recordHobbsMeterReadingAction = action as? RecordHobbsMeterReadingAction {

            let reading = (recordHobbsMeterReadingAction.isPreFlight ?? false) ? flightInfo.preFlightHobbsReading : flightInfo.postFlightHobbsReading

            

            let payload = RecordHobbsMeterReadingPayload(

                onChecklistItem?.details?[0],

                onChecklistItem?.details?[1],

                recordHobbsMeterReadingAction.isPreFlight,

                reading,

                flightInfo.setHobbsMeterReading,

                completionCallback)

    

            DispatchQueue.main.async(execute: {()->Void in

                self.performSegue(withIdentifier: "ShowHobbsReadingNotepad", sender: payload)

            })

        } else {

            if let completionCallback = completionCallback {

                completionCallback()

            }

        }

        

    }

    func recordWeatherCondition(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)

    {

        if let _ = action as? RecordWeatherConditionsAction {

            let payload = RecordWeatherConditionsPayload(

                barometerReading: flightInfo.barometerReading,

                windDirection: flightInfo.windDirection,

                windSpeed: flightInfo.windSpeed,

                temperature: flightInfo.temperature,

                item: onChecklistItem!.details![0],

                action: onChecklistItem!.details![1],

                setWeatherConditionsCallback: flightInfo.setWeatherConditions,

                completionCallback: completionCallback)

            

            DispatchQueue.main.async(execute: {()->Void in

                self.performSegue(withIdentifier: "ShowRecordWeatherNotepad", sender: payload)

            })

        } else {

            if let completionCallback = completionCallback {

                completionCallback()

            }

        }

    }

    

    fileprivate var timer = Timer()

    fileprivate var showFlightTime = true

    

    func updateTimer() {

        if let flightStartTime = self.flightInfo.flightStartTime {

            if let _ = self.flightInfo.flightEndTime {

                timer.invalidate()

            } else {

                if self.showFlightTime {

                    self.showFlightTime(flightStartTime as Date);

                }else {

                    self.showRemainingFlightTime(flightStartTime as Date);

                }

            }

        } else {

            timer.invalidate()

        }

    }

    

    fileprivate func showFlightTime(_ flightStartTime:Date) {

        let now = Date()

        let interval = now.timeIntervalSince(flightStartTime)

        

        let miliseconds = (interval * 10000).truncatingRemainder(dividingBy: 10000);

        let seconds = interval.truncatingRemainder(dividingBy: 60)

        let minutes = (interval / 60).truncatingRemainder(dividingBy: 60)

        let hours = (interval / 3600)

        

        let msg = String(format: "%02.0f : %02.0f : %02.0f . %04.0f", hours, minutes, seconds, miliseconds );

        

        tbFlightTime?.text = msg

    }

    

    fileprivate func showRemainingFlightTime(_ flightStartTime : Date) {

        let now = Date()

        let interval = now.timeIntervalSince(flightStartTime)

        

        let approximateFlightTime = self.flightInfo.calcApproximateFlightTime() * 3600

        let remainingTime = approximateFlightTime - Float(interval);

        

        let miliseconds = (remainingTime * 10000).truncatingRemainder(dividingBy: 10000);

        let seconds = remainingTime.truncatingRemainder(dividingBy: 60)

        let minutes = (remainingTime / 60).truncatingRemainder(dividingBy: 60)

        let hours = (remainingTime / 3600)

        

        let msg = String(format: "%02.0f : %02.0f : %02.0f . %04.0f", hours, minutes, seconds, miliseconds );

        

        tbFlightTime?.text = msg

    }

    

    @IBAction func toggleShownTime() {

        self.showFlightTime = !self.showFlightTime

        

        if self.showFlightTime {

            btnToggleTimeShown?.setTitle("Flight Time", for: UIControlState())

        } else {

            btnToggleTimeShown?.setTitle("Remaining", for: UIControlState())

        }

    }

    

    func startFlightTimer(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {

        self.flightInfo.flightStartTime = Date()

        self.flightInfo.flightEndTime = nil

        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(ChecklistViewController.updateTimer), userInfo: nil, repeats: true)



        self.showFlightTime = true

        if self.showFlightTime {

            btnToggleTimeShown?.setTitle("Flight Time", for: UIControlState())

        } else {

            btnToggleTimeShown?.setTitle("Remaining", for: UIControlState())

        }

        

        if let completionCallback = completionCallback {

            completionCallback()

        }

    }

    

    func stopFlightTimer(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {

        self.flightInfo.flightEndTime = Date()

        timer.invalidate()

        self.showFlightTime = true

        if let completionCallback = completionCallback {

            completionCallback()

        }

    }

    

    func showTimer(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {

        if let sta = action as? ShowTimerAction {

            let payload = ShowTimerPayload(

                onChecklistItem?.details?[0],

                onChecklistItem?.details?[1],

                sta.duration,

                completionCallback: completionCallback)

            DispatchQueue.main.async(execute: {()->Void in

                self.performSegue(withIdentifier: "ShowTimer", sender: payload)

            })

        } else {

            if let completionCallback = completionCallback {

                completionCallback()

            }

        }

    }

    func showMapVneActions(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {

        if let _ = action as? ShowMapVNEChartsAction {
            let payload = ShowMapVNEChartsPayload(
                Float(self.flightInfo.temperature),
                onChecklistItem?.details?[0],
                onChecklistItem?.details?[1],
                completionCallback: completionCallback)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.performSegue(withIdentifier: "ShowMapVneCharts", sender: payload)
            })
        } else {
            if let completionCallback = completionCallback {
                completionCallback()
            }
        }
    }
}
