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
    var newCity: Weather?
    
    @IBOutlet var labelNewCity: UITextField!
    
    @IBOutlet var buttonSave: UIBarButtonItem!
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        buttonSave.isEnabled = false
        labelNewCity.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    func saveCity() {
        //let newCity = Weather(city: labelNewCity.text!, temp: "", windDirection: "", windSpeed: "", pressure: "", humidity: "")
        if currentCity != nil {
            currentCity?.city = labelNewCity.text!
        } else {
            newCity = Weather(city: labelNewCity.text!, temp: "", windDirection: "", windSpeed: "", pressure: "", humidity: "")
            //weathers.append(newCity!)
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
    @objc private func textFieldChanged() {
        if labelNewCity.text?.isEmpty == false {
            buttonSave.isEnabled = true
        } else {
            buttonSave.isEnabled = false
        }
    }
   }