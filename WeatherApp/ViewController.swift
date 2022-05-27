//
//  ViewController.swift
//  WeatherApp
//
//  Created by user on 27.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    
    
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.delegate = self
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        textGrabing()
        searchTextField.endEditing(true)
    }
    
    
    func textGrabing() {
        if searchTextField.text != "" {
            networkManager.fetchCurrentWeather(cityName: searchTextField.text!)
            searchTextField.placeholder = "Search"
        } else {
            // should add an alert message <<<<<<<<<<<<<<<<<<<<<<<<<<<------------------------
            searchTextField.placeholder = "Type something..."
        }
    }
}

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

    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

