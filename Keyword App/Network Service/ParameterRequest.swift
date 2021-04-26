
import Foundation

class ParameterRequest {
    init() {}
    
    var parameters = [String: Any]()
    
    static let difficulty   = "difficulty"
    static let cr           = "cr"
    static let project      = "project"
    static let category     = "category"
    static let content_type = "content_type"
    
    static let loc_name_canonical = "loc_name_canonical"
    static let key = "key"
    static let data = "data"
    static let keys = "keys"
    static let country_code = "country_code"
    static let language = "language"
    static let keywords = "keywords"
    static let limit = "limit"
    
    func addParameter(key: String, value: Any?) {
        parameters[key] = value
    }
    
    func addKeyForKeysearchAPI() {
        addParameter(key: ParameterRequest.key, value: "55c572THQRMmV53b08f792FsBQmReV")
    }
}
