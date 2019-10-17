//
//  CustomTableViewCell.swift
//  Weather
//
//  Created by Macbook on 16.10.2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var labelCity: UILabel! //Город
    @IBOutlet var labelTemp: UILabel! //Температура
    @IBOutlet var labelWindDirection: UILabel! //Направление ветра
    @IBOutlet var labelWindSpeed: UILabel! //Сила ветра
    @IBOutlet var labelPressure: UILabel!//Давление
    @IBOutlet var labelHumidity: UILabel!//Влажность
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
}
