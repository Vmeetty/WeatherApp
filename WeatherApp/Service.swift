//
//  Service.swift
//  WeatherApp
//
//  Created by user on 27.05.2022.
//

import Foundation


struct Service {
    
    static let shared = Service()
    
    init(){}
    
    func getConditionStringName(with conditionId: Int) -> String {
        switch conditionId {
        case 200...232: return "cloud.bolt"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "cloud.snow"
        case 701...781: return "cloud.fog"
        case 800: return "sun.max"
        case 801...804: return "cloud"
        default: return "cloud"
        }
    }
    
}
