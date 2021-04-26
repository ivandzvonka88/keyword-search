
import Foundation

class DataforseoResponse {
    var status: String
    var task_id: Int
    var results_time: String
    var results_count: Int
    var error: [ErrorDataforseo]?
    var results: Any?//[[String: Any]]
    
    init(data: [String: Any]) {
        status = data["status"] as? String ?? ""
        task_id = data["task_id"] as? Int ?? 0
        results_time = data["results_time"] as? String ?? ""
        results_count = data["results_count"] as? Int ?? 0
        results = data["results"]
        if let arrError = data["error"] as? [[String: Any]] {
            error = [ErrorDataforseo]()
            for infoData in arrError {
                let errorInfo = ErrorDataforseo(data: infoData)
                error?.append(errorInfo)
            }
        }
    }
}

class ErrorDataforseo {
    var code: Int
    var message: String
    
    init(data: [String: Any]) {
        code = data["code"] as? Int ?? 0
        message = data["task_id"] as? String ?? ""
    }
}
