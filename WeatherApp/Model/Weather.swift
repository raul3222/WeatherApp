//
//  Weather.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 18.12.2021.
//

import Foundation

struct Weather: Codable {
    let location: Location
    let current: Current
    
    
    init(weatherData: [String: Any]) {
        let locationDict = weatherData["location"] as? [String: Any] ?? [:]
        location = Location(value: locationDict)
        let currentDict = weatherData["current"] as? [String: Any] ?? [:]
        current = Current(value: currentDict)
        
    }
    static func getWeather(from value: Any) -> [Weather]{
        guard let weatherData = value as? [String: Any] else {return []}
        return [Weather(weatherData: weatherData)]
    }
}

struct Location: Codable {
    let name: String
    let country: String
    let localtime: String
    
    init(value: [String: Any]) {
        name = value["name"] as? String ?? ""
        country = value["country"] as? String ?? ""
        localtime = value["localTime"] as? String ?? ""
    }
}

struct Current: Codable {
    let temp_c: Int
    let condition: Condition
    let wind: Double

    init(value: [String: Any]) {
        temp_c = value["temp_c"] as? Int ?? 0
        wind = value["wind_kph"] as? Double ?? 0
        let conditionDict = value["condition"] as? [String: Any] ?? [:]
        condition = Condition(value: conditionDict)
        
    }
}

struct Condition: Codable {
    let text: String
    let icon: String
    
    init(value: [String: Any]) {
        text = value["text"] as? String ?? ""
        icon = value["icon"] as? String ?? ""
    }
}




