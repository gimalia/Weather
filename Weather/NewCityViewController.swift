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
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        //следующий код только для первого запуска при сохранении данных в базу данных
/*        DispatchQueue.main.async {
            self.newCity.saveWeathers()
        }
*/
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
    if labelNewCity.text?.isEmpty == true {
        buttonSave.isEnabled = false
    } else {
        buttonSave.isEnabled = true
    }
    
      //  buttonSave.isEnabled = true //только в том случае, если город есть, иначе false
        return true
    }
  
    @objc private func textFieldChanged() {
        if labelNewCity.text?.isEmpty == false {
            buttonSave.isEnabled = true
        } else {
            buttonSave.isEnabled = false
        }
    }
}
//
//extension NewCityViewController: UITextFieldDelegate {
//
//}
