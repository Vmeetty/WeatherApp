//
//  ViewController.swift
//  WeatherApp
//
//  Created by user on 27.05.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tempStack: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var forecasts = [ForecastModel]()
    
    private let locationManager = CLLocationManager()
    var networkManager = NetworkManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI(hiden: true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        networkManager.delegate = self
        searchTextField.delegate = self
        tableView.dataSource = self
    }
    

    @IBAction func searchPressed(_ sender: UIButton) {
        textGrabing()
        searchTextField.endEditing(true)
    }
    @IBAction func locationPressed(_ sender: UIButton) {
        indicator.startAnimating()
        locationManager.requestLocation()
    }
    
    
    func textGrabing() {
        if searchTextField.text != "" {
            indicator.startAnimating()
            networkManager.fetchWeather(cityName: searchTextField.text!)
            searchTextField.placeholder = "Search"
        } else {
            searchTextField.placeholder = "Type something..."
        }
    }
    
    func configUI(hiden: Bool) {
        cityLabel.isHidden = hiden
        conditionImageView.isHidden = hiden
        tempStack.isHidden = hiden
    }
}


//MARK: - TableView DataSource section

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.shared.cellID, for: indexPath) as! ForecastTableViewCell
        cell.configureCellBy(forecasts[indexPath.row])
        return cell
    }
    
}


//MARK: - TextFieldDelegate section

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textGrabing()
        searchTextField.endEditing(true)
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
}

extension ViewController: NetworkManagerDelegate {
    func didUpdateForecast(_ forecasts: [ForecastModel]) {
        DispatchQueue.main.async {
            self.forecasts = forecasts
            self.tableView.reloadData()
        }
    }

    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.indicator.stopAnimating()
            self.configUI(hiden: false)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate section

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    locationManager.requestLocation()
                @unknown default:
                    break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            indicator.startAnimating()
            networkManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

