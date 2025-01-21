//
//  Storage.swift
//  UIScreens
//
//  Created by Matthew Siu on 8/12/2022.
//

import Foundation
import UIKit

class LocalStorage{
    
    enum StorageType {
        case userDefaults
        case fileSystem
    }
    
    enum KeychainError: Error {
        // Attempted read for an item that does not exist.
        case itemNotFound
        
        // Attempted save to override an existing item.
        // Use update instead of save to update existing items
        case duplicateItem
        
        // A read of an item in any format other than Data
        case invalidItemFormat
        
        // Any operation result status than errSecSuccess
        case unexpectedStatus(OSStatus)
    }
    
}

// save to local storage
extension LocalStorage{
    
    /* --------------------- *
     *        SAVE
     * --------------------- */
    
    static func save(suiteName: String? = nil, _ key: String, _ param: Any?){
        let userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName)! : UserDefaults.standard
        userDefaults.set(param, forKey: key)
    }
    
    static func saveObj<T>(_ key: String, _ param: T) where T: Encodable{
        do {
            let data = try JSONEncoder().encode(param)
            UserDefaults.standard.set(data, forKey: key)
        }catch{
            print("cannot save key=\(key) in UserDefaults")
        }
            
    }
    
    // save img
    static func save(img: UIImage,
                        forKey key: String,
                        withStorageType storageType: StorageType) {
        if let pngRepresentation = img.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation,
                                            forKey: key)
            }
        }
    }
    
    /* --------------------- *
     *        GET
     * --------------------- */
    
    static func checkKeyExist(suiteName: String? = nil, _ key: String) -> Bool{
        let userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName)! : UserDefaults.standard
        return userDefaults.object(forKey: key) != nil
    }
    
    static func getBool(suiteName: String? = nil, _ key: String) -> Bool{
        let userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName)! : UserDefaults.standard
        return userDefaults.bool(forKey: key)
    }
    
    static func getInt(suiteName: String? = nil, _ key: String) -> Int?{
        let userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName)! : UserDefaults.standard
        return userDefaults.integer(forKey: key)
    }
    
    static func getString(suiteName: String? = nil, _ key: String) -> String?{
        let userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName)! : UserDefaults.standard
        return userDefaults.string(forKey: key)
    }
    
    static func getDict(suiteName: String? = nil, _ key: String) -> [String: Any]?{
        let userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName)! : UserDefaults.standard
        return userDefaults.dictionary(forKey: key)
    }
    
    static func getArray(suiteName: String? = nil, _ key: String) -> Array<Any>?{
        let userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName)! : UserDefaults.standard
        return userDefaults.array(forKey: key)
    }
    
    static func getDouble(suiteName: String? = nil, _ key: String) -> Double?{
        let userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName)! : UserDefaults.standard
        return (userDefaults.object(forKey: key) != nil) ? userDefaults.double(forKey: key) : nil
    }
    
    static func getObject<T: Codable>(_ key: String, to type: T.Type) -> T?{
        if let data = UserDefaults.standard.data(forKey: key){
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                return object
            } catch {
                print("unable to decode: \(error)")
                return nil
            }
        }
        return nil
    }
    
    // get img
    static func retrieveImage(forKey key: String,
                                inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
                let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return nil
    }
    
    private static func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    /* --------------------- *
     *        REMOVE
     * --------------------- */
    
    static func remove(suiteName: String? = nil, _ key: String){
        let userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName)! : UserDefaults.standard
        return userDefaults.removeObject(forKey: key)
        
    }
    
    static func removeAll(){
        func clearTempFolder() {
            let fileManager = FileManager.default
            let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
            let documentsPath = documentsUrl.path
            
            do {
                if let documentPath = documentsPath
                {
                    let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                    print("all files in cache: \(fileNames)")
                    for fileName in fileNames {
                        print("find \(fileName)")
                        if (fileName.hasSuffix(".png"))
                        {
                            let filePathName = "\(documentPath)/\(fileName)"
                            try fileManager.removeItem(atPath: filePathName)
                        }
                    }
                    
                    let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                    print("all files in cache after deleting images: \(files)")
                }
                
            } catch {
                print("Could not clear temp folder: \(error)")
            }
        }
        
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        
        clearTempFolder()
    }
    
    static func removeAll(exception: [String]){
        var exceptionList : [String: Any] = [:]
        for id in exception {
            exceptionList[id] = LocalStorage.getString(id)
        }
        removeAll()
        for id in exception {
            if exceptionList[id] != nil, let list = exceptionList[id]{
                LocalStorage.save(id, list)
            }
        }
    }
    
    /* --------------------- *
     *        DEBUG
     * --------------------- */
    
    static func printAll(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
    }
    
}

// save to keyChain
extension LocalStorage{
    static func saveLoginInfo(ac: String, pw: String) throws{
        let account = ac
        let password = pw.data(using: .utf8)
        let service = Bundle.main.bundleIdentifier ?? ""
        
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass uniquely identify the item to update in Keychain
                kSecAttrService as String: service as AnyObject,
                kSecAttrAccount as String: account as AnyObject,
                kSecClass as String: kSecClassGenericPassword,
                kSecValueData as String: password as AnyObject
            ]
        
        // SecItemAdd attempts to add the item identified by the query to keychain
        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }

        // Any status other than errSecSuccess indicates the save operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func saveLoginInfo(_ key: String, pw: String) throws{
        guard let pwData = pw.data(using: .utf8) else {
            fatalError("PW can't be convert to expected object")
        }
        let identifier = Bundle.main.bundleIdentifier ?? "" + ".keys." + key
        guard let tag = identifier.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueRef as String: pwData
        ]
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func readLoginInfo(_ key: String) throws -> String{
        let identifier = Bundle.main.bundleIdentifier ?? "" + ".keys." + key
        let tag = identifier.data(using: .utf8)!
        let getquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
//        let value = item as! SecKey
        guard let passwordData = item as? Data else {
            throw KeychainError.invalidItemFormat
        }
        let password = String(decoding: passwordData, as: UTF8.self)
        print("value = \(password)")
        return password
    }
    
    static func readLoginInfo(ac: String) throws -> String {
        let account = ac
        let service = Bundle.main.bundleIdentifier ?? ""
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass uniquely identify the item to read in Keychain
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne, // kSecMatchLimitOne indicates keychain should read only the most recent item matching this query

            // kSecReturnData is set to kCFBooleanTrue in order to retrieve the data for the item
            kSecReturnData as String: kCFBooleanTrue
        ]

        // SecItemCopyMatching will attempt to copy the item identified by query to the reference itemCopy
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary,&itemCopy)

        // errSecItemNotFound is a special status indicating the read item does not exist. Throw itemNotFound so the client can determine whether or not to handle this case
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        // Any status other than errSecSuccess indicates the read operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        // This implementation of KeychainInterface requires all items to be saved and read as Data. Otherwise, invalidItemFormat is thrown
        guard let passwordData = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        let password = String(decoding: passwordData, as: UTF8.self)
        
        return password
    }
    
    static func deleteLoginInfo(ac: String) throws {
        let account = ac
        let service = Bundle.main.bundleIdentifier ?? ""
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass uniquely identify the item to delete in Keychain
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]

        // SecItemDelete attempts to perform a delete operation for the item identified by query. The status indicates if the operation succeeded or failed.
        let status = SecItemDelete(query as CFDictionary)

        // Any status other than errSecSuccess indicates the
        // delete operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func cleanKeychain(){
        print("cleanKeychain")
        let secItemClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity
        ]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            print("clear spec \(spec)")
            SecItemDelete(spec)
        }
    }
}
