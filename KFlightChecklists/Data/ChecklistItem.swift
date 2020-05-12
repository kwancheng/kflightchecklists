//
//  ChecklistItem.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChecklistItem {
    var type : ChecklistType?
    var actionHasNote:Bool?
    var itemHasNote:Bool?
    var details : [String]?
    var preAction : Action?
    var postAction : Action?
    
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
        
        self.preAction = Action.instantiateActionFromJson(jsonData["pre_action"])
        self.postAction = Action.instantiateActionFromJson(jsonData["post_action"])
        
        self.details = []
        if let detailsJsonArray = jsonData["details"].array {
            for detailJson in detailsJsonArray {
                if let detailStr = detailJson.string {
                    self.details?.append(detailStr)
                }
            }
        }
    }
}
