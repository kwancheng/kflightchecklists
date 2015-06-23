//
//  Payload.swift
//  KFlightChecklists
//
//  Created by Congee on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class Payload {
    var itemStr : String?
    var actionStr : String?
    var completionCallback : (()->Void)?
}