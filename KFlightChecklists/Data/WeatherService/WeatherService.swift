//
//  WeatherService.swift
//  KFlightChecklists
//
//  Created by Congee on 11/1/15.
//  Copyright © 2015 Acproma llc. All rights reserved.
//

import Foundation
import Alamofire
import AEXML

typealias MetarSuccessHanlder = (metarEntry : MetarEntry?) -> ()
typealias MetarFailureHandler = (error : String) -> ()

class WeatherService {
    static let sharedService = WeatherService()
    
    let server = "https://www.aviationweather.gov/adds/dataserver_current/httpparam"
    
    func getMetar(airportCode : String, success :MetarSuccessHanlder, failure:MetarFailureHandler) {
        let queryParams = [
            "dataSource" : "metars",
            "requestType" : "retrieve",
            "format" : "xml",
            "stationString" : airportCode,
            "hoursBeforeNow" : "1"
        ]
        
        Alamofire.request(.GET, server, parameters: queryParams, encoding: ParameterEncoding.URL, headers: nil)
        .response { (request, response, data, error) -> Void in
            do {
                let xmlDoc = try AEXMLDocument(xmlData: data!)
                if let numResults = Int(xmlDoc.root["data"].attributes["num_results"]!) {
                    if(numResults < 1) {
                        success(metarEntry: nil)
                    } else {
                        success(metarEntry: MetarEntry(xmlElem: xmlDoc.root["data"].children[0]))
                    }
                }
            } catch {
                print("Error retrieving metar for airport \(airportCode). Error \(error)")
                failure(error: "Shit")
            }
        }
    }
}