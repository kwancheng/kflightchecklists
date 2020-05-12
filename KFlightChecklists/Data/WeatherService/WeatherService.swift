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

typealias MetarSuccessHanlder = (_ metarEntry : MetarEntry?) -> ()
typealias MetarFailureHandler = (_ error : String) -> ()

class WeatherService {
    static let sharedService = WeatherService()
    
    let server = "https://www.aviationweather.gov/adds/dataserver_current/httpparam"
    
    func getMetar(_ airportCode : String, success :@escaping MetarSuccessHanlder, failure:@escaping MetarFailureHandler) {
        let queryParams : Parameters? = [
            "dataSource" : "metars",
            "requestType" : "retrieve",
            "format" : "xml",
            "stationString" : airportCode,
            "hoursBeforeNow" : "1"
        ]
        
        Alamofire.request(server, method: HTTPMethod.get, parameters: queryParams, encoding: URLEncoding.default, headers: [:])
            .response { (response) in
                do {
                    guard let data = response.data else { return }
                    
                    let xmlDoc = try AEXMLDocument(xml: data)
                    if let numResults = Int(xmlDoc.root["data"].attributes["num_results"]!) {
                        if(numResults < 1) {
                            success(nil)
                        } else {
                            success(MetarEntry(xmlElem: xmlDoc.root["data"].children[0]))
                        }
                    }
                } catch {
                    print("Error retrieving metar for airport \(airportCode). Error \(error)")
                    failure("Shit")
                }
            }
    }
}
