//
//  MainViewController.swift
//  Weather
//
//  Created by Macbook on 16.10.2019.
//  Copyright © 2019 Macbook. All rights reserved.
//
        
        
import UIKit
import RealmSwift

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

class MainViewController: UITableViewController, UIGestureRecognizerDelegate {
   
    var weathers: Results<Weather>!
    var indicatorIsHidden: Bool = true
    var currentCity = Weather(city: "", temp: "", windDirection: "", windSpeed: "", pressure: "", humidity: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weathers = realm.objects(Weather.self)
        if weathers.count == 0 {
            // следующий код только для первого запуска при сохранении данных в базу данных

               print("первый запуск программы")
                currentCity.saveWeathers()
            
        }
        fetchData()
        gesture()
    }
    
    @objc func reportVerticalSwipe(gesture: UISwipeGestureRecognizer) {
        //print("получаем данные...")
        fetchData()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
          return true
    }
    
    func gesture() {
        let vertical = UISwipeGestureRecognizer(target: self, action: #selector(reportVerticalSwipe))
        vertical.direction = UISwipeGestureRecognizer.Direction.down
        vertical.delegate = self
        tableView.addGestureRecognizer(vertical)
    }
    
    func findWindDirection(direction: Double) -> String {
       
        let windDirectionString: [String] = [
            "С",
            "С-В",
            "В",
            "Ю-В",
            "Ю",
            "Ю-З",
            "З",
            "С-З",
            "С"
        ]
        let windDirectionArray = [
        [0, 22],
        [23, 67],
        [68, 112],
        [113, 157],
        [158, 202],
        [203, 247],
        [248, 292],
        [293, 337],
        [338, 359]
        ]
        
        let iDirection = Int(direction)
        var k = 0
        for i in windDirectionArray {
            if i[0] <= iDirection && iDirection <= i[1] {
                return windDirectionString[k]
            }
            k+=1
        }
        return ""
    }
    
    func fetchData() {
         for i in 0..<weathers.count {
             loadWeather(index: i) { (finish) in
                 if finish {
                     //self.tableView.reloadData()
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
        cell.labelCity?.text = weather.city
        cell.labelTemp?.text = weather.temp
        cell.labelWindDirection?.text = weather.windDirection
        cell.labelWindSpeed?.text = weather.windSpeed
        cell.labelPressure?.text = weather.pressure
        cell.labelHumidity?.text = weather.humidity
        cell.activityIndicator.hidesWhenStopped = true
        cell.activityIndicator.isHidden = indicatorIsHidden
        if indicatorIsHidden {
            cell.activityIndicator.stopAnimating()
        } else {
            cell.activityIndicator.startAnimating()
        }
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
        fetchData()
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
        let cityNew = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let jsonUrlString = URL_string + cityNew! + "&units=metric" + API_key
        guard let url = URL(string: jsonUrlString) else { return}
        indicatorIsHidden = false
        tableView.reloadData()
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let weatherSave = try JSONDecoder().decode(WeatherStruct.self, from: data)
                DispatchQueue.main.async {
                    
                    let newWeather = Weather(
                        city: weatherSave.name,
                        temp: String(Int(weatherSave.main.temp))+"℃",
                        windDirection: self.findWindDirection(direction: weatherSave.wind.deg),
                        windSpeed: String(Int(weatherSave.wind.speed)) + "м/с",
                        pressure: String(Int(weatherSave.main.pressure * 0.75)) + " мм.рт.ст.",
                        humidity: String(Int(weatherSave.main.humidity)) + "%")
     
                    try! realm.write {
                        self.weathers[index].temp = newWeather.temp
                        self.weathers[index].windSpeed = newWeather.windSpeed
                        self.weathers[index].windDirection = newWeather.windDirection
                        self.weathers[index].pressure = newWeather.pressure
                        self.weathers[index].humidity = newWeather.humidity
                        self.indicatorIsHidden = true
                     }
                    self.tableView.reloadData()
                }
            } catch {
                handler(false)
            }
        }.resume()
        handler(true)
       
    }
}

