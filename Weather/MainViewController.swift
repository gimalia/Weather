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

    var weathers: Results<Weather>!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        weathers = realm.objects(Weather.self)
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
}
