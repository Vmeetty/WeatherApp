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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCellBy(_ forcast: ForecastModel) {
        conditionImageView.image = UIImage(systemName: forcast.conditionName)
        temperatureLabel.text = forcast.temperatureString
        dayLabel.text = forcast.humanDate
    }
    

}
