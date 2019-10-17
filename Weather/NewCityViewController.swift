//
//  NewCityViewController.swift
//  Weather
//
//  Created by Macbook on 16.10.2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class NewCityViewController: UITableViewController {

    var currentCity: Weather?
    
    @IBOutlet var labelNewCity: UITextField!
    
    @IBOutlet var buttonSave: UIBarButtonItem!
    
    @IBOutlet var indicatorActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
 
        indicatorActivity.hidesWhenStopped = true
        indicatorActivity.isHidden = true
        buttonSave.isEnabled = false
        self.labelNewCity.delegate = self
        labelNewCity.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
    }
    func saveCity() {

        let newWeather = Weather(city: labelNewCity.text!, temp: "", windDirection: "", windSpeed: "", pressure: "", humidity: "")
        if currentCity != nil {
            try! realm.write {
                currentCity?.city = newWeather.city
            }
            
        } else {
            StorageManager.saveObject(newWeather)
        }
        
    }
    
    private func setupEditScreen() {
        if currentCity != nil {
            setupNavigationBar()
            labelNewCity.text = currentCity?.city
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentCity?.city
        buttonSave.isEnabled = true
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
   
}

extension NewCityViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //проверить наличие города
        if labelNewCity.text?.isEmpty == false {
            indicatorActivity.isHidden = false
            indicatorActivity.startAnimating()
            findCity(city: labelNewCity.text!) { (finish) in
                DispatchQueue.main.async {
                    if !finish {
                        self.labelNewCity.text = self.labelNewCity.text! + " - такой город не найден"
                        self.buttonSave.isEnabled = false
                    } else {
                        self.buttonSave.isEnabled = true
                    }
                }
            }
            indicatorActivity.isHidden = true
            indicatorActivity.stopAnimating()
        }
        return true
    }
  
    @objc private func textFieldChanged() {
        if labelNewCity.text?.isEmpty == true {
            buttonSave.isEnabled = false
        }
    }

    
    func findCity(city: String, handler: @escaping (_ status: Bool) -> ()) {
        let API_key = "&APPID=2feda31e3043ce19f44dc16f6eab0efe"
        let URL_string = "http://api.openweathermap.org/data/2.5/weather?q="
        let cityNew = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let jsonUrlString = URL_string + cityNew! + "&units=metric" + API_key
        guard let url = URL(string: jsonUrlString) else {
            print(jsonUrlString)
            handler(false)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {
                handler(false)
                return
            }
            do {
                _ = try JSONDecoder().decode(WeatherStruct.self, from: data)
                 handler(true)
            } catch {
                handler(false)
            }
        }.resume()
    }
}

/*
cell.activityIndicator.hidesWhenStopped = true
cell.activityIndicator.isHidden = indicatorIsHidden
if indicatorIsHidden {
    cell.activityIndicator.stopAnimating()
} else {
    cell.activityIndicator.startAnimating()
}
*/
