//
//  Checklist.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Checklist {
    open var title : String?
    open var sections : [Section]?
    
    public init(_ jsonData: JSON){
        self.title = jsonData["title"].string
        self.sections = []
        if let arrJson = jsonData["sections"].array {
            for elemJson in arrJson {
                self.sections?.append(Section(elemJson))
            }
        }
    }
}
