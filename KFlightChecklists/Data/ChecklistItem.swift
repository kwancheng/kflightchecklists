//
//  ChecklistItem.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ChecklistItem {
    public var type : ChecklistType?
    public var actionHasNote:Bool?
    public var itemHasNote:Bool?
    public var details : [String]?
    public var preAction : Action?
    public var postAction : Action?
    
    public init(_ jsonData : JSON){
        if let typeStr = jsonData["type"].string {
            switch typeStr {
            case "ITEM_ACTION" :
                self.type = ChecklistType.ActionItem
            case "CAUTION" :
                self.type = ChecklistType.Caution
            case "NOTE" :
                self.type = ChecklistType.Note
            default :
                self.type = nil
            }
        }
        
        actionHasNote = jsonData["action_has_note"].bool
        itemHasNote = jsonData["item_has_note"].bool
        
        self.preAction = instantiateAction(jsonData["pre_action"])
        self.postAction = instantiateAction(jsonData["post_action"])
        
        self.details = []
        if let detailsJsonArray = jsonData["details"].array {
            for detailJson in detailsJsonArray {
                if let detailStr = detailJson.string {
                    self.details?.append(detailStr)
                }
            }
        }
    }
    
    private func instantiateAction(jsonData:JSON) -> Action? {
        var retAction : Action? = Action(jsonData)
        
        if let actionName = retAction?.name {
            switch actionName {
                case "ShowMessage" :
                    retAction = ShowMessageAction(jsonData)
                case "FuelQuantityNotepad" :
                    break
                default :
                    retAction = nil
            }
        } else {
            retAction = nil
        }
        
        return retAction
    }
}