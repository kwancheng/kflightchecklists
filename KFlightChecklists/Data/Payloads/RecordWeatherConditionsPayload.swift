//
//  RecordWeatherConditionsPayload.swift
//  KFlightChecklists
//
//  Created by Congee on 6/25/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import Foundation

public typealias SetWeatherConditionsCallback = (_ barometerReading : Float, _ windDirection: Int, _ windSpeed:Int, _ temperature:Int)->Void

open class RecordWeatherConditionsPayload :Payload {
    open var barometerReading : Float?
    open var windDirection : Int?
    open var windSpeed : Int?
    open var temperature : Int?
    open var setWeatherConditionsCallback : SetWeatherConditionsCallback?
    
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
