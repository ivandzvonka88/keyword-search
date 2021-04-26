
import Foundation

struct UserData {
    init() {}
    
    var uid: String?
    var username: String?
    var credits: Int?
    
    init(dic: [String : Any]) {
        self.uid = dic["uid"] as? String
        self.username = dic["username"] as? String
        self.credits = dic["credits"] as? Int
    }
    
    var dictionary: [String: Any] {
        return [
            "uid": uid as Any,
            "username": username as Any,
            "credits": credits as Any
        ]
    }
}
