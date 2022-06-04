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
    func didUpdateForecast(_ forecasts: [ForecastModel])
    func didFailWithError(error: Error)
}

struct NetworkManager {
    
    weak var delegate: NetworkManagerDelegate?
    
    private let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ace498cd3f6f1233bd5177301ccbe956&units=metric"
    private let forecastURL = "https://api.openweathermap.org/data/2.5/forecast/daily?appid=ace498cd3f6f1233bd5177301ccbe956&units=metric&cnt=16"
    
  
    //MARK: - URL preparing
    
    func fetchWeather(cityName: String) {
        let urlString = "\(currentWeatherURL)&q=\(cityName)"
        performCurrentWeatherRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(currentWeatherURL)&lat=\(latitude)&lon=\(longitude)"
        performCurrentWeatherRequest(with: urlString)
    }
    
    func fetchForecast(latitude: Double, longitude: Double) {
        let urlString = "\(forecastURL)&lat=\(latitude)&lon=\(longitude)"
        performForecastRequest(with: urlString)
    }
    
    
    
    //MARK: -  Networking
    
    private func performCurrentWeatherRequest(with urlStr: String) {
        if let url = URL(string: urlStr) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                guard let currentWeatherData = data else {
                    fatalError("Fail to get currentWeatherData")
                }
                guard let currentWeather = parseCurrentWeatherJSON(currentWeatherData) else {
                    fatalError("Fail to parse currentWeather data")
                }
                let longitude = currentWeather.lon
                let latitude = currentWeather.lat
                fetchForecast(latitude: latitude, longitude: longitude)
            
                self.delegate?.didUpdateWeather(self, weather: currentWeather)
            }
            task.resume()
        }
    }
    
    private func performForecastRequest(with urlStr: String) {
        if let forecastURL = URL(string: urlStr) {
            let forecastSession = URLSession(configuration: .default)
            let forecastTask = forecastSession.dataTask(with: forecastURL) { forecastData, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                guard let forcastData = forecastData else {
                    fatalError("Fail to get forecastData")
                }
                guard let forecasts = parseForecastJSON(forcastData) else {
                    fatalError("Fail to parse forecast data")
                }
                self.delegate?.didUpdateForecast(forecasts)
            }
            forecastTask.resume()
        }
    }
    
    

    private func parseCurrentWeatherJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedCurrentWeatherData = try decoder.decode(WeatherData.self, from: data)
            let name = decodedCurrentWeatherData.name
            let temp = decodedCurrentWeatherData.main.temp
            let conditionID = decodedCurrentWeatherData.weather[0].id
            let lon = decodedCurrentWeatherData.coord.lon
            let lat = decodedCurrentWeatherData.coord.lat
            let weather = WeatherModel(lon: lon, lat: lat, conditionId: conditionID, cityName: name, temperature: temp)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    private func parseForecastJSON(_ data: Data) -> [ForecastModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedForecastData = try decoder.decode(ForecastData.self, from: data)
            var forecastArray = [ForecastModel]()
            for item in decodedForecastData.list {
                let dayTemp = item.temp.day
                let conditionID = item.weather[0].id
                let dt = item.dt
                let forecast = ForecastModel(conditionId: conditionID, temperature: dayTemp, timeStamp: dt)
                forecastArray.append(forecast)
            }
            return forecastArray
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
