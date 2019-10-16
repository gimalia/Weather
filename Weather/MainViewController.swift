//
//  MainViewController.swift
//  Weather
//
//  Created by Macbook on 16.10.2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    
    let names = ["Ine","tow","dhet","Fiebv","Sixx"]
    var weathers = [Weather(city: "Kazan", temp: "5℃", windDirection: "с-з", windSpeed: "10 м/с", pressure: "760 мм.рт.ст.", humidity: "60%")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return weathers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        // Configure the cell...
        //cell.textLabel?.text = names[indexPath.row]
        //let i = indexPath.row
        let weather = weathers[indexPath.row]
        cell.labelCity?.text = weather.city
        cell.labelTemp?.text = weather.temp
        cell.labelWindDirection?.text = weather.windDirection
        cell.labelWindSpeed?.text = weather.windSpeed
        cell.labelPressure?.text = weather.pressure
        cell.labelHumidity?.text = weather.humidity
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let weather = weathers[indexPath.row]
//        //let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _,_ in (_, _)
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {_,_,_ in
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            })
//            // дописать код удаления данных из массива и хранилища
//            //tableView.deleteRows(at: [indexPath], with: .automatic)
//
//        return deleteAction
//    }
  
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let weather = weathers[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {
            (_, _) in
            // дописать код удаления данных из массива и хранилища
            self.weathers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {_,_,_ in
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            })
            // дописать код удаления данных из массива и хранилища
            //tableView.deleteRows(at: [indexPath], with: .automatic)
        return [deleteAction]
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newCityVC = segue.source as? NewCityViewController else { return }
        newCityVC.saveCity()
//        weathers.append(newCityVC.newCity!)
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
    // MARK: - Table view delegate
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 130
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
