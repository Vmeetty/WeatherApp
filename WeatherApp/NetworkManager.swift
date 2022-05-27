//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by user on 27.05.2022.
//

import Foundation
import CoreLocation


protocol NetworkManagerDelegate: AnyObject {
    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct NetworkManager {
    
    weak var delegate: NetworkManagerDelegate?
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=ace498cd3f6f1233bd5177301ccbe956&units=metric"
    
    func fetchCurrentWeather(cityName: String) {
        let urlString = "\(baseURL)&q=\(cityName)"
        performRequestBy(with: urlString)
    }
    
    func fetchCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        performRequestBy(with: urlString)
    }
    
    private func performRequestBy(with urlStr: String) {
        if let url = URL(string: urlStr) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    private func parseJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let conditionId = decodedData.weather[0].id
            let weather = WeatherModel(conditionId: conditionId, cityName: name, temperature: temp)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
