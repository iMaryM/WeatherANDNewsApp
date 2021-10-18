//
//  RealmManager.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 18.10.21.
//

import UIKit
import RealmSwift

class RealmManager {
    public static let shared = RealmManager()
    
    let localRealm = try! Realm()
    
    func saveRequestInfo(by requestInfo: RequestInfoDB) {
        do {
            try localRealm.write {
                localRealm.add(requestInfo)
            }
        } catch (let e) {
            print(e)
        }
    }
}
