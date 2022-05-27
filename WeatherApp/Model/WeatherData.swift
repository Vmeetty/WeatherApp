//
//  WeatherData.swift
//  WeatherApp
//
//  Created by user on 27.05.2022.
//

import Foundation


struct WeatherData: Codable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
