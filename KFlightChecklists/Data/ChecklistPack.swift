//
//  ChecklistPack.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ChecklistPack {
    public var title : String?
    public var checklists : [Checklist]?
    
    public init(){
        if let path = NSBundle.mainBundle().pathForResource("Checklists", ofType: "json") {
            if let content = NSData(contentsOfFile: path) {
                var error : NSErrorPointer = NSErrorPointer()
                var jsonData = JSON(data: content, options: NSJSONReadingOptions.MutableContainers, error: error)
                
                if let error = jsonData.error {
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