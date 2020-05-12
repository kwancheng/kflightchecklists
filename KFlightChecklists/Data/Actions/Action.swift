//
//  Action.swift
//  KFlightChecklists
//
//  Created by Congee on 6/17/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Action {
    open var actionDelegate : ActionDelegate?
    open var name : String?
    
    public init(_ jsonData : JSON) {
        self.name = jsonData["name"].string
    }
    
    open func execute(_ checklistItem : ChecklistItem?, completionCallback : CompletionCallback?) {
        if let actionDelegate = self.actionDelegate {
            if let _ = self as? ShowMessageAction {
                actionDelegate.showMessage(self, onChecklistItem: checklistItem, completionCallback: completionCallback)
            } else if let _ = self as? RecordFuelQuantityAction {
                actionDelegate.recordFuelQuantity(self, onChecklistItem: checklistItem, completionCallback: completionCallback!)
            } else if let _ = self as? RecordHobbsMeterReadingAction {
                actionDelegate.recordHobbsMeterReading(self, onChecklistItem: checklistItem, completionCallback: completionCallback!)
            } else if let _ = self as? RecordWeatherConditionsAction {
                actionDelegate.recordWeatherCondition(self, onChecklistItem: checklistItem, completionCallback: completionCallback!)
            } else if let _ = self as? StartFlightTimerAction {
                actionDelegate.startFlightTimer(self, onChecklistItem: checklistItem, completionCallback: completionCallback!)
            } else if let _ = self as? StopFlightTimerAction {
                actionDelegate.stopFlightTimer(self, onChecklistItem: checklistItem, completionCallback: completionCallback!)
            } else if let _ = self as? ShowTimerAction {
                actionDelegate.showTimer(self, onChecklistItem: checklistItem, completionCallback: completionCallback!)
            } else if let _ = self as? ShowMapVNEChartsAction {
                actionDelegate.showMapVneActions(self, onChecklistItem: checklistItem, completionCallback: completionCallback)
            }
        }
    }
        
    static public func instantiateActionFromJson(_ jsonData : JSON) -> Action? {
        var retAction : Action?
        
        if let actionName = jsonData["name"].string {
            switch actionName {
                case "ShowMessage" :
                    retAction = ShowMessageAction(jsonData)
                case "RecordFuelQuantity" :
                    retAction = RecordFuelQuantityAction(jsonData)
                case "RecordHobbsMeterReading" :
                    retAction = RecordHobbsMeterReadingAction(jsonData)
                case "RecordWeatherConditionAction":
                    retAction = RecordWeatherConditionsAction(jsonData)
                case "StartFlightTimer" :
                    retAction = StartFlightTimerAction(jsonData)
                case "StopFlightTimer" :
                    retAction = StopFlightTimerAction(jsonData)
                case "ShowTimer" :
                    retAction = ShowTimerAction(jsonData)
                case "ShowMapVNECharts" :
                    retAction = ShowMapVNEChartsAction(jsonData)
                default :
                    break
            }
        }
        
        return retAction
    }
}
