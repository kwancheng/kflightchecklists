//
//  FlightInfo.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public class FlightInfo {
    public let mainTankCapacity : Float = 19.2
    public let auxTankCapacity : Float = 10.5
    public let gallonsPerHour : Float = 10
    
    public var mainTankLevel : Float = 0
    public var auxTankLevel : Float = 0
    
    public var preFlightHobbsReading : Float = 0
    public var postFlightHobbsReading : Float = 0
    
    public func calcActualMainLevel() -> Float {
        return self.mainTankCapacity * self.mainTankLevel
    }
    
    public func calcActualAuxLevel() -> Float {
        return self.auxTankCapacity * self.auxTankLevel
    }
    
    public func calcApproximateFlightTime() -> Float {
        return (self.calcActualMainLevel() + self.calcActualAuxLevel()) / gallonsPerHour
    }
}