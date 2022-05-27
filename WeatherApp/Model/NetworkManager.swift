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
    func didUpdateForecast(_ forecasts: [WeatherModel])
    func didFailWithError(error: Error)
}

struct NetworkManager {
    
    weak var delegate: NetworkManagerDelegate?
    
    private let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ace498cd3f6f1233bd5177301ccbe956&units=metric"
    private let forecastURL = "https://api.openweathermap.org/data/2.5/forecast/daily?appid=ace498cd3f6f1233bd5177301ccbe956&units=metric&cnt=16"
    
  
    //MARK: - URL preparing
    
    func fetchCurrentWeather(cityName: String) {
        let urlString = "\(currentWeatherURL)&q=\(cityName)"
        performRequestBy(with: urlString)
    }
    
    func fetchCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(currentWeatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequestBy(with: urlString)
    }
    
    func fetchForcast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(forecastURL)&lat=\(latitude)&lon=\(longitude)"
        performRequestBy(with: urlString, andForecast: true)
    }
    
    
    //MARK: -  Networking
    
    private func performRequestBy(with urlStr: String, andForecast forecast: Bool = false) {
        if let url = URL(string: urlStr) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if forecast {
                        if let forecasts = parseForecastJSON(safeData) {
                            self.delegate?.didUpdateForecast(forecasts)
                        }
                    } else {
                        if let weather = parseCurrentWeatherJSON(safeData) {
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    
    private func parseCurrentWeatherJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedCurrentWeatherData = try decoder.decode(WeatherData.self, from: data)
            let name = decodedCurrentWeatherData.name
            let temp = decodedCurrentWeatherData.main.temp
            let conditionId = decodedCurrentWeatherData.weather[0].id
            let weather = WeatherModel(conditionId: conditionId, cityName: name, temperature: temp)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    private func parseForecastJSON(_ data: Data) -> [WeatherModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedForecastData = try decoder.decode(ForecastData.self, from: data)
            var forecastArray = [WeatherModel]()
            for item in decodedForecastData.list {
                let dayTemp = item.temp.day
                let conditionID = item.weather[0].id
                let weather = WeatherModel(conditionId: conditionID, cityName: nil, temperature: dayTemp)
                forecastArray.append(weather)
            }
            return forecastArray
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
