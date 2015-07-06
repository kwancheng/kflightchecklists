//
//  ActionDelegate.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/24/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public typealias CompletionCallback = (()->Void)
public typealias SetFuelLevelCallback = (mainTankLevel : Float, auxTankLevel : Float)->Void

public protocol ActionDelegate {
    func showMessage(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func recordFuelQuantity(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func recordHobbsMeterReading(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func recordWeatherCondition(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func startFlightTimer(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func stopFlightTimer(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func showTimer(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func showMapVneActions(action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
}