//
//  FlightInfo.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/21/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

class FlightInfo {
    public let mainTankCapacity : Float = 19.2
    public let auxTankCapacity : Float = 10.5
    public let gallonsPerHour : Float = 10
    
    var mainTankLevel : Float = 0
    var auxTankLevel : Float = 0
    
    var preFlightHobbsReading : Float = 0
    var postFlightHobbsReading : Float = 0
    
    var barometerReading : Float = 29.95
    var windDirection = 180
    var windSpeed = 20
    var temperature = 10
    
    var flightStartTime : Date?
    var flightEndTime : Date?
    
    public let maxFor5Min = 0.9
    
    func calcActualMainLevel() -> Float {
        return self.mainTankCapacity * self.mainTankLevel
    }
    
    func calcActualAuxLevel() -> Float {
        return self.auxTankCapacity * self.auxTankLevel
    }
    
    func calcApproximateFlightTime() -> Float {
        return (self.calcActualMainLevel() + self.calcActualAuxLevel()) / gallonsPerHour
    }
    
    func setFuelQuantityCallback( _ mainTankLevel : Float, auxTankLevel : Float)  {
        self.mainTankLevel = mainTankLevel
        self.auxTankLevel = auxTankLevel
    }
    
    func setHobbsMeterReading(_ isPreFlight : Bool, _ reading : Float ) {
        if(isPreFlight) {
            self.preFlightHobbsReading = reading
        } else {
            self.postFlightHobbsReading = reading
        }
    }

    func setWeatherConditions(_ barometerReading:Float, windDirection: Int, windSpeed : Int, temperature : Int)
    {
        self.barometerReading = barometerReading
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.temperature = temperature
    }
}
