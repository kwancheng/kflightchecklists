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
        print("Metar Element \(xmlElem.xmlString)")
        
        self.rawText = xmlElem["raw_text"].stringValue
        self.stationId = xmlElem["station_id"].stringValue
        self.observationTime = xmlElem["observation_time"].stringValue
        self.latitude = xmlElem["latitude"].doubleValue
        self.longitude = xmlElem["longitude"].doubleValue
        self.tempC = xmlElem["temp_c"].doubleValue
        self.dewPointC = xmlElem["dewpoint_c"].doubleValue
        self.windDirDegrees = xmlElem["wind_dir_degrees"].intValue
        self.windSpdKts = xmlElem["wind_speed_kt"].intValue
        self.visibilitySM = xmlElem["visibility_statute_mi"].doubleValue
        self.altimHg = xmlElem["altim_in_hg"].doubleValue
        self.flightCategory = xmlElem["flight_category"].stringValue
        self.metarType = xmlElem["metar_type"].stringValue
        self.elevationMeter = xmlElem["elevation_m"].doubleValue
    }
}