//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by user on 27.05.2022.
//

import Foundation


struct ForecastModel {
    let conditionId: Int
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var conditionName: String {
        return Service.shared.getConditionStringName(with: conditionId)
    }
}
