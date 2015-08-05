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
    
    public var barometerReading : Float = 29.95
    public var windDirection = 180
    public var windSpeed = 20
    public var temperature = 10
    
    public var flightStartTime : NSDate?
    public var flightEndTime : NSDate?
    
    public let maxFor5Min = 0.9
    
    public func calcActualMainLevel() -> Float {
        return self.mainTankCapacity * self.mainTankLevel
    }
    
    public func calcActualAuxLevel() -> Float {
        return self.auxTankCapacity * self.auxTankLevel
    }
    
    public func calcApproximateFlightTime() -> Float {
        return (self.calcActualMainLevel() + self.calcActualAuxLevel()) / gallonsPerHour
    }
    
    public func setFuelQuantityCallback( mainTankLevel : Float, auxTankLevel : Float)  {
        self.mainTankLevel = mainTankLevel
        self.auxTankLevel = auxTankLevel
    }
    
    public func setHobbsMeterReading(isPreFlight : Bool, _ reading : Float ) {
        if(isPreFlight) {
            self.preFlightHobbsReading = reading
        } else {
            self.postFlightHobbsReading = reading
        }
    }

    public func setWeatherConditions(barometerReading:Float, windDirection: Int, windSpeed : Int, temperature : Int)
    {
        self.barometerReading = barometerReading
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.temperature = temperature
    }
}