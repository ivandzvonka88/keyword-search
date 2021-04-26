
import Foundation

class KeywordLocationInfo {
    var loc_id: Int
    var loc_name_canonical: String
    var country_code: String
    var language: String
    var count: Int
    
    init(data: [String: Any]) {
        loc_id = data["loc_id"] as? Int ?? 0
        loc_name_canonical = data["loc_name_canonical"] as? String ?? ""
        country_code = data["country_code"] as? String ?? ""
        language = data["language"] as? String ?? ""
        count = data["count"] as? Int ?? 0
    }
}
