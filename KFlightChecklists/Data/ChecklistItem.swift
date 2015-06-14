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