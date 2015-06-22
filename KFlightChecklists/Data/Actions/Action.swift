//
//  Action.swift
//  KFlightChecklists
//
//  Created by Congee on 6/17/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Action {
    public var type : String?
    
    public init(_ jsonData : JSON) {
        self.type = jsonData["type"].string
    }
}