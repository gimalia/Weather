//
//  MainViewController.swift
//  Weather
//
//  Created by Macbook on 16.10.2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
   
   
    struct WeatherStruct: Decodable {
        struct mainStruct: Decodable {
            let temp: Double
            let pressure: Double
            let humidity: Double
        }
        struct windStruct: Decodable {
            let speed: Double
            let deg: Double
        }
        let name: String
        let main: mainStruct
        let wind : windStruct
    }
    
    struct objectData: Decodable {
        let data: [WeatherStruct]
    }
    
    var weathers: Results<Weather>!
    
    var weatherSave: WeatherStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weathers = realm.objects(Weather.self)
        for i in 0..<weathers.count {
            loadWeather(index: i) { (finish) in
                if finish {
                    self.tableView.reloadData()
                }
            }
        }
    }
        
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return weathers.isEmpty ? 0 : weathers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let weather = weathers[indexPath.row]
        
        
//             newWeather = Weather(city: weatherTemp.name, temp: String(weatherTemp.main.temp), windDirection: String(weatherTemp.wind.deg), windSpeed: String(weatherTemp.wind.speed), pressure: String(weatherTemp.main.pressure), humidity: String(weatherTemp.main.humidity))
        
//        try! realm.write {
//                    weather.city = newWeather!.city
//                    weather.humidity = newWeather!.humidity
//                    weather.pressure = newWeather!.pressure
//                    weather.temp = newWeather!.temp
//                    weather.windDirection = newWeather!.windDirection
//                    weather.windSpeed = newWeather!.windSpeed
//        }
        //let weather = weathers[indexPath.row]
      //  cell.labelCity?.text = weather?.name
//        cell.labelTemp?.text = String(weather!.main.temp)
//        cell.labelWindDirection?.text = weather.wind.direction
//        cell.labelWindSpeed?.text = weather.wind.speed
//        cell.labelPressure?.text = weather.pressure
//        cell.labelHumidity?.text = weather.humidity
        
        cell.labelCity?.text = weather.city
        cell.labelTemp?.text = weather.temp
        cell.labelWindDirection?.text = weather.windDirection
        cell.labelWindSpeed?.text = weather.windSpeed
        cell.labelPressure?.text = weather.pressure
        cell.labelHumidity?.text = weather.humidity
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let weather = weathers[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {
            (_, _) in
            StorageManager.deleteObject(weather)
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
        return [deleteAction]
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newCityVC = segue.source as? NewCityViewController else { return }
        newCityVC.saveCity()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let weather = weathers[indexPath.row]
            let newCityVC = segue.destination as! NewCityViewController
            newCityVC.currentCity = weather
        }
    }
    

    func loadWeather(index: Int, handler: @escaping (_ status: Bool) -> ()) {
        let API_key = "&APPID=2feda31e3043ce19f44dc16f6eab0efe"
        let URL_string = "http://api.openweathermap.org/data/2.5/weather?q="
        let city = weathers[index].city
        let cityNew = city.replacingOccurrences(of: " ", with: "\u{20}", options: .regularExpression, range: nil)
        let jsonUrlString = URL_string + cityNew + "&units=metric" + API_key
        print(jsonUrlString)
        guard let url = URL(string: jsonUrlString) else { return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
//            print(data)
            do {
                self.weatherSave = try JSONDecoder().decode(WeatherStruct.self, from: data)
//                self.weatherTmpObj = try JSONDecoder().decode(objectData.self, from: data)
//                self.weatherTmp = self.weatherTmpObj!.data
                //handler(true)
//                print(self.weatherSave?.name)
            } catch {
                print("Город не найден " + city)
            }
        }.resume()
        handler(true)
       
    }
}


