//
//  RemoteConfigManager.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 2.11.21.
//

import Foundation
import FirebaseRemoteConfig

enum RCKey: String {
    case kindOfMaps
}

class RemoteConfigManager {
    public static let shared = RemoteConfigManager()
    
    var defaultValues: [String : Any] = ["kindOfMaps" : "Apple"]
    
    var isActivated: Bool = false
    
    init() {
        RemoteConfig.remoteConfig().setDefaults(defaultValues as? [String : NSObject])
    }
    
    func connectToFireBaseRC() {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0.0) { status, error in
            guard status == .success else {
                print(error?.localizedDescription ?? "Error")
                return
            }
        }
        
        RemoteConfig.remoteConfig().activate { isActivated, error in
            self.isActivated = isActivated
            
            if !isActivated {
                print(error?.localizedDescription ?? "Error")
            }
        }
    }
    
    func getStringValue(from key: RCKey) -> String? {
        return RemoteConfig.remoteConfig()[key.rawValue].stringValue
    }

}
