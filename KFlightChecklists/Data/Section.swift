//
//  Section.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Section {
    public var title : String?
    public var checklistItems : [ChecklistItem]?
    
    public init(_ jsonData : JSON) {
        self.title = jsonData["title"].string
        
        self.checklistItems = []
        if let checklistItemsArray = jsonData["checklist_items"].array {
            for checklistItemJson in checklistItemsArray {
                var checklistItem = ChecklistItem(checklistItemJson)
                self.checklistItems?.append(checklistItem)
            }
        }
    }
}