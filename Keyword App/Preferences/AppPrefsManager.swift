
import UIKit
import CoreLocation


class AppPrefsManager: NSObject {

    static let shared = AppPrefsManager()
    
    private let USER_LOGIN            = "USER_LOGIN"
    private let USER_DATA             = "USER_DATA"
    private let AUTH_TOKEN            = "AUTH_TOKEN"
    
    
    func setDataToPreference(data: AnyObject, forKey key: String) {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(archivedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getDataFromPreference(key: String) -> AnyObject? {
        let archivedData = UserDefaults.standard.object(forKey: key)
        
        if(archivedData != nil) {
            return NSKeyedUnarchiver.unarchiveObject(with: archivedData! as! Data) as AnyObject?
        }
        return nil
    }
    
    func removeDataFromPreference(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func isKeyExistInPreference(key: String) -> Bool {
        if(UserDefaults.standard.object(forKey: key) == nil) {
            return false
        }
        return true
    }
    
    private func setData<T: Codable>(data: T, forKey key: String) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(jsonData, forKey: key)
            UserDefaults.standard.synchronize()
        } catch let error {
            print(error)
        }
    }
    
    private func getData<T: Codable>(objectType: T.Type, forKey key: String) -> T? {
        guard let result = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(objectType, from: result)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    // MARK: - User Login
    func setIsUserLogin(isUserLogin: Bool) {
        setDataToPreference(data: isUserLogin as AnyObject, forKey: USER_LOGIN)
    }
    
    func isUserLogin() -> Bool {
        let isUserLogin = getDataFromPreference(key: USER_LOGIN)
        return isUserLogin == nil ? false: (isUserLogin as! Bool)
    }
    
    func removeUserLogin() {
        removeDataFromPreference(key: USER_LOGIN)
    }
    /*
    // MARK: - Auth
    func setAuth(auth: String) {
        setDataToPreference(data: auth as AnyObject, forKey: AUTH_TOKEN)
    }

    func getAuth() -> String {
        return getDataFromPreference(key: AUTH_TOKEN) as! String
    }
    
    func removeAuth() {
        removeDataFromPreference(key: AUTH_TOKEN)
    }
    
    // MARK: - User Data
    func setUserResulModel(model: UserData) {
        setDataToPreference(data: model.dictionary as AnyObject, forKey: USER_DATA)
    }

    func getUserResulModel() -> UserData {
        let dictionary = getDataFromPreference(key: USER_DATA) as! [String : Any]
        return UserData(dic: dictionary)
    }*/
}
