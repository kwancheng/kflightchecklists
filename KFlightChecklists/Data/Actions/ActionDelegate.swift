//
//  ActionDelegate.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/24/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public typealias CompletionCallback = (()->Void)
public typealias SetFuelLevelCallback = (_ mainTankLevel : Float, _ auxTankLevel : Float)->Void

protocol ActionDelegate {
    func showMessage(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func recordFuelQuantity(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func recordHobbsMeterReading(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func recordWeatherCondition(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func startFlightTimer(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func stopFlightTimer(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func showTimer(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
    func showMapVneActions(_ action : Action, onChecklistItem : ChecklistItem?, completionCallback : CompletionCallback?)
}
