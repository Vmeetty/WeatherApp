//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by user on 27.05.2022.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    private var savedForecast: ForecastModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        conditionImageView.image = nil
        temperatureLabel.text = nil
    }
    
    func configureCellBy(_ forecast: ForecastModel) {
        savedForecast = forecast
        if forecast.humanDate == savedForecast.humanDate {
            conditionImageView.image = UIImage(systemName: forecast.conditionName)
            temperatureLabel.text = forecast.temperatureString
            dayLabel.text = forecast.humanDate
        }
    }
    

}
