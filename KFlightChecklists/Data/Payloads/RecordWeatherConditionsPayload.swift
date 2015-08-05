//
//  RecordWeatherConditionsPayload.swift
//  KFlightChecklists
//
//  Created by Congee on 6/25/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public typealias SetWeatherConditionsCallback = (barometerReading : Float, windDirection: Int, windSpeed:Int, temperature:Int)->Void

public class RecordWeatherConditionsPayload :Payload {
    public var barometerReading : Float?
    public var windDirection : Int?
    public var windSpeed : Int?
    public var temperature : Int?
    public var setWeatherConditionsCallback : SetWeatherConditionsCallback?
    
    public init(barometerReading:Float, windDirection : Int, windSpeed:Int, temperature:Int, item:String, action:String?, setWeatherConditionsCallback : SetWeatherConditionsCallback?, completionCallback : CompletionCallback?)
    {
        super.init(item, action, completionCallback)
        self.barometerReading = barometerReading
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.temperature = temperature
        self.setWeatherConditionsCallback = setWeatherConditionsCallback
    }
}