//
//  loadWeather.swift
//  Weather
//
//  Created by Macbook on 16.10.2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation

struct WeatherMain: Decodable {
    var temp: Double
    var pressure: Double
    var humidity: Double
}

struct WeatherWind: Decodable {
    var speed: Double
    var deg: Double
}
struct WeatherStruct: Decodable {
    var name: String
    var main: WeatherMain
    var wind : WeatherWind
}

func loadWeather(city: String) {
        
        let API_key = "&APPID=2feda31e3043ce19f44dc16f6eab0efe"
        let URL_string = "http://api.openweathermap.org/data/2.5/weather?q="
        let jsonUrlString = URL_string + city + "&units=metric" + API_key
       
        guard let url = URL(string: jsonUrlString) else { return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(WeatherStruct.self, from: data)
                print(weather.main.temp)
            } catch let jsonErr {
                print("Error serializaing json: ", jsonErr)
            }
        }.resume()
    }

/*
{"coord": { "lon": 139,"lat": 35},
  "weather": [
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01n"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 289.92,
    "pressure": 1009,
    "humidity": 92,
    "temp_min": 288.71,
    "temp_max": 290.93
  },
  "wind": {
    "speed": 0.47,
    "deg": 107.538
  },
  "clouds": {
    "all": 2
  },
  "dt": 1560350192,
  "sys": {
    "type": 3,
    "id": 2019346,
    "message": 0.0065,
    "country": "JP",
    "sunrise": 1560281377,
    "sunset": 1560333478
  },
  "timezone": 32400,
  "id": 1851632,
  "name": "Shuzenji",
  "cod": 200
}
 */
/*
API key:
- Your API key is 2feda31e3043ce19f44dc16f6eab0efe
- Within the next couple of hours, it will be activated and ready to use
- You can later create more API keys on your account page
- Please, always use your API key in each API call

Endpoint:
- Please, use the endpoint api.openweathermap.org for your API calls
- Example of API call:
api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=2feda31e3043ce19f44dc16f6eab0efe
*/
/*
struct WebsiteDescription: Decodable {
    let name: String
    let description: String
    let courses: [Course]
}

struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrlString = "https://api.letsbuildthatapp.com/jsondecodable/courses_missing_fields"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            //let dataAsString = String(data: data,encoding: .utf8)
            //print(dataAsString)
            do {
                //let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                //print(websiteDescription.name, websiteDescription.description)
                
                let courses = try JSONDecoder().decode([Course].self, from: data)
                print(courses)
            } catch let jsonErr {
                print("Error serializaing json: ", jsonErr)
            }
        }.resume()
    }

   
}
*/

