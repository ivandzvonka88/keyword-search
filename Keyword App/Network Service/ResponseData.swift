
import Foundation

struct ResponseData {
    let status: Int
    let msg: String
    
    init(data: [String : Any]) {
        status = data["status"] as? Int ?? 201
        msg = data["msg"] as? String ?? ""
    }
}

struct ResponseStatus {
    static let success = 200
    static let fail = 201
//    static let serverError = 500
//    static let userNotFound = 401
}
