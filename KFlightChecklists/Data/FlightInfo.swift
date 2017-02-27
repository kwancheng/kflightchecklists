//
//  FlightInfo.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

open class FlightInfo {        
    open let mainTankCapacity : Float = 19.2
    open let auxTankCapacity : Float = 10.5
    open let gallonsPerHour : Float = 10
    
    open var mainTankLevel : Float = 0
    open var auxTankLevel : Float = 0
    
    open var preFlightHobbsReading : Float = 0
    open var postFlightHobbsReading : Float = 0
    
    open var barometerReading : Float = 29.95
    open var windDirection = 180
    open var windSpeed = 20
    open var temperature = 10
    
    open var flightStartTime : Date?
    open var flightEndTime : Date?
    
    open let maxFor5Min = 0.9
    
    open func calcActualMainLevel() -> Float {
        return self.mainTankCapacity * self.mainTankLevel
    }
    
    open func calcActualAuxLevel() -> Float {
        return self.auxTankCapacity * self.auxTankLevel
    }
    
    open func calcApproximateFlightTime() -> Float {
        return (self.calcActualMainLevel() + self.calcActualAuxLevel()) / gallonsPerHour
    }
    
    open func setFuelQuantityCallback( _ mainTankLevel : Float, auxTankLevel : Float)  {
        self.mainTankLevel = mainTankLevel
        self.auxTankLevel = auxTankLevel
    }
    
    open func setHobbsMeterReading(_ isPreFlight : Bool, _ reading : Float ) {
        if(isPreFlight) {
            self.preFlightHobbsReading = reading
        } else {
            self.postFlightHobbsReading = reading
        }
    }

    open func setWeatherConditions(_ barometerReading:Float, windDirection: Int, windSpeed : Int, temperature : Int)
    {
        self.barometerReading = barometerReading
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.temperature = temperature
    }
}
