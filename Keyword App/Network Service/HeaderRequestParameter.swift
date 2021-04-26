
import Foundation

class HeaderRequestParameter {
    var parameters = [String : String]()
    
    static let Deviceid = "Deviceid"
    static let Studentid = "Studentid"
    
    static let Authorization = "Authorization"
    
    init() {
        
    }
    
    func addAuthorizationForDataforseo() {
        let user = Application.dataforseoApiLogin
        let password = Application.dataforseoApiPass
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        addParameter(key: HeaderRequestParameter.Authorization, value: "Basic \(base64Credentials)")
    }

    func addParameter(key: String, value: String) {
        parameters[key] = value
    }
}
