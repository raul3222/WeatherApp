//
//  Cities.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 22.12.2021.
//

import Foundation

struct Cities: Codable {
    let city: String?
    let country: String?
    
    init(value: [String: Any]) {
        city = value["city"] as? String
        country = value["country"] as? String
    }
    
    static func getCities(from value: Any) -> [Cities] {
        guard let value = value as? [String : Any] else { return [] }
        guard let data = value["data"] as? [[String: Any]] else { return [] }
        return data.compactMap { Cities(value: $0)}
    }
}


