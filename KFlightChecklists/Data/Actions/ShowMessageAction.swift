//
//  ShowMessageAction.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/19/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ShowMessageAction : Action {
    public var message : String?
    
    override init(_ jsonData: JSON) {
        super.init(jsonData)
        self.message = jsonData["message"].string
    }
}