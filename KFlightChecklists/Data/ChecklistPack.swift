//
//  ChecklistPack.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChecklistPack {
    var title : String?
    var checklists : [Checklist]?
    
    public init(){
        if let path = Bundle.main.path(forResource: "Checklists", ofType: "json") {
            if let content = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                if let jsonData = try? JSON(data: content, options: JSONSerialization.ReadingOptions.mutableContainers) {
                    if let _ = jsonData.error {
                        // TODO : handle json parse error
                    } else {
                        self.title = jsonData["title"].string
                        self.checklists = []
                        if let arr = jsonData["checklists"].array {
                            for elem in arr {
                                self.checklists?.append(Checklist(elem))
                            }
                        }
                    }
                } else {
                    // TODO: Handle nil jsonData
                }
            }
        }
    }
}
