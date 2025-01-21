//
//  RemoteConfigManager.swift
//  black screen camera
//
//  Created by Matthew Siu on 10/4/2024.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

typealias RC = RemoteConfigManager
class RemoteConfigManager{
    static let shared = RemoteConfigManager()
    
    let remoteConfig: RemoteConfig
    
    enum Key: String{
        case versionUpdate = "versionUpdate"
    }
    
    init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 12
        remoteConfig.configSettings = settings
    }
    
    func initialize(completion: @escaping (Bool) -> Void){
        self.remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
        self.fetch { result in
            completion(result)
            if result{
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Constants.Noti.RCUpdateNotification, object: nil)
                }
            }
        }
    }
    
    func fetch(completion: @escaping (Bool) -> Void){
        print("remoteConfig: start fetch")
        Task{
            let result = try await remoteConfig.fetchAndActivate()
            switch result{
            case .successFetchedFromRemote:
                print("remoteConfig: fetchAndActivate - successFetchedFromRemote")
                completion(true)
                break
            case .successUsingPreFetchedData:
                print("remoteConfig: successUsingPreFetchedData")
                completion(true)
                break
            case .error:
                print("remoteConfig: Error")
                completion(false)
                break
            @unknown default:
                print("remoteConfig: Error")
                completion(false)
            }
        }
    }
}

// utils
extension RemoteConfigManager{
    private func decodeJSON<T: Decodable>(key: Key, type: T.Type) -> T? {
        do {
            if let json = remoteConfig.configValue(forKey: key.rawValue).jsonValue as? [String: Any]{
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                print("remoteConfig key=\(key) | \(json)")
                let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
                return decodedObject
            }else{
                print("remoteConfig: Error: data is nil or can't convert to dictionary type from key=\(key)")
            }
            return nil
        } catch {
            print("remoteConfig: Error decoding \(key) JSON: \(error) from key=\(key.rawValue)")
            do{
                if let json = remoteConfig.defaultValue(forKey: key.rawValue)?.jsonValue as? [String: Any] {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    print("remoteConfig get defaults key=\(key) | \(json)")
                    let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
                    return decodedObject
                }else{
                    return nil
                }
            }catch{
                return nil
            }
        }
    }
}

// RC param
extension RemoteConfigManager{
    func getVersionUpdate() -> RCVersionUpdateRepo?{
        return self.decodeJSON(key: .versionUpdate, type: RCVersionUpdateRepo.self)
    }
}
