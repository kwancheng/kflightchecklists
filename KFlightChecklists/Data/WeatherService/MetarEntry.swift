//
//  MetarEntry.swift
//  KFlightChecklists
//
//  Created by Congee on 11/1/15.
//  Copyright © 2015 Acproma llc. All rights reserved.
//

import Foundation
import AEXML

class MetarEntry {
    var rawText: String
    var stationId : String
    var observationTime : String
    var latitude : Double
    var longitude : Double
    var tempC : Double
    var dewPointC : Double
    var windDirDegrees : Int
    var windSpdKts : Int
    var visibilitySM : Double
    var altimHg : Double
    var flightCategory : String
    var metarType : String
    var elevationMeter : Double
    
    init(xmlElem : AEXMLElement) {
        print("Metar Element \(xmlElem.xml)")
        
        self.rawText = xmlElem["raw_text"].string
        self.stationId = xmlElem["station_id"].string
        self.observationTime = xmlElem["observation_time"].string
        self.latitude = xmlElem["latitude"].double ?? 0
        self.longitude = xmlElem["longitude"].double ?? 0
        self.tempC = xmlElem["temp_c"].double ?? 0
        self.dewPointC = xmlElem["dewpoint_c"].double ?? 0
        self.windDirDegrees = xmlElem["wind_dir_degrees"].int ?? 0
        self.windSpdKts = xmlElem["wind_speed_kt"].int ?? 0
        self.visibilitySM = xmlElem["visibility_statute_mi"].double ?? 0
        self.altimHg = xmlElem["altim_in_hg"].double ?? 0
        self.flightCategory = xmlElem["flight_category"].string
        self.metarType = xmlElem["metar_type"].string
        self.elevationMeter = xmlElem["elevation_m"].double ?? 0
    }
}
