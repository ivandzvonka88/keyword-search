
import Foundation

class MonthlySearchInfo {
    var year: Int
    var month: Int
    var count: Int
    
    init(data: [String: Any]) {
        year = data["year"] as? Int ?? 0
        month = data["month"] as? Int ?? 0
        count = data["count"] as? Int ?? data["search_volume"] as? Int ?? 0
    }
    
    func getJson() -> [String: Any] {
        var dict = [String: Any]()
        dict["year"] = year
        dict["month"] = month
        dict["count"] = count
        return dict
    }
}
