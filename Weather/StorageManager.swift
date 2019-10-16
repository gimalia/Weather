//
//  StorageManager.swift
//  Weather
//
//  Created by Macbook on 16.10.2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject(_ weather : Weather) {
        try! realm.write {
            realm.add(weather)
        }
    }
    
    static func deleteObject(_ weather: Weather) {
        try! realm.write {
            realm.delete(weather)
        }
    }
}
