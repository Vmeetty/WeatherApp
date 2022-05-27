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
    let timeStamp: Double
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var conditionName: String {
        return Service.shared.getConditionStringName(with: conditionId)
    }
    
    var humanDate: String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let customFormat = "ddMMMM"
        let gbLocale = Locale(identifier: "en_GB")
        let ukFormat = DateFormatter.dateFormat(fromTemplate: customFormat, options: 0, locale: gbLocale)
        let formatter = DateFormatter()
        formatter.dateFormat = ukFormat
        let localDate = formatter.string(from: date)
        return localDate
    }
}
