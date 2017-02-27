//
//  ChecklistPack.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

open class ChecklistPack {
    open var title : String?
    open var checklists : [Checklist]?
    
    public init(){
        if let path = Bundle.main.path(forResource: "Checklists", ofType: "json") {
            if let content = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let error : NSErrorPointer = nil
                var jsonData = JSON(data: content, options: JSONSerialization.ReadingOptions.mutableContainers, error: error)
                
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
            }
        }
    }
}
