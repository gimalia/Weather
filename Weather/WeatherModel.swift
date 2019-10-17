//
//  WeatherModel.swift
//  Weather
//
//  Created by Macbook on 16.10.2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import RealmSwift

class Weather: Object {
    @objc dynamic var city = ""
    @objc dynamic var temp = ""
    @objc dynamic var windDirection = ""
    @objc dynamic var windSpeed = ""
    @objc dynamic var pressure = ""
    @objc dynamic var humidity = ""
    
    convenience init(city: String, temp: String, windDirection: String, windSpeed: String, pressure: String, humidity: String) {
        self.init()
        self.city = city
        self.temp = temp
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.pressure = pressure
        self.humidity = humidity
    }

    // Установка начальных данных при первой загрузке приложения
    let cities = ["Kazan","Moscow","New York","Paris"]
    
    func saveWeathers() {
        for city in cities {
            let newWeather = Weather()
            newWeather.city = city
            newWeather.temp = "5℃"
            newWeather.humidity = "50%"
            newWeather.pressure = "800 мм.рт.ст"
            newWeather.windDirection = "С-З"
            newWeather.windSpeed = " 10 м/с"
            StorageManager.saveObject(newWeather)
        }
    }
}
