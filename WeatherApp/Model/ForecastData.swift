//
//  ForecastData.swift
//  WeatherApp
//
//  Created by user on 27.05.2022.
//

import Foundation


struct ForecastData: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dt: Double
    let temp: Temp
    let weather: [Weather]
}

struct Temp: Codable {
    let day: Double
}
