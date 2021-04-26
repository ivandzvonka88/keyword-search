
import Foundation

class VolumeSearchInfo {
    var language: String
    var loc_id: Int
    var key: String
    var cmp: Double
    var cpc: Double
    var sv: Int
    var categories: [Int]
    var ms: [MonthlySearchInfo]
    
    var country_code: String
    var competition: Double
    
    var score: String = ""
    
    var isSelected = false
    var isSaved = false
    
    init(data: [String: Any]) {
        language = data["language"] as? String ?? ""
        loc_id = data["loc_id"] as? Int ?? 0
        key = data["key"] as? String ?? ""
        cmp = data["cmp"] as? Double ?? 0
        cpc = data["cpc"] as? Double ?? 0
        sv = data["sv"] as? Int ?? data["search_volume"] as? Int ?? 0
        categories = data["categories"] as? [Int] ?? []
        ms = [MonthlySearchInfo]()
        if let arrMs = data["ms"] as? [[String: Any]] {
            for infoData in arrMs {
                let monthlyInfo = MonthlySearchInfo(data: infoData)
                ms.append(monthlyInfo)
            }
        } else if let arrMs = data["history"] as? [[String: Any]] {
            for infoData in arrMs {
                let monthlyInfo = MonthlySearchInfo(data: infoData)
                ms.append(monthlyInfo)
            }
        }
        
        country_code = data["country_code"] as? String ?? ""
        competition = data["competition"] as? Double ?? 0
    }
    
    func getJson() -> [String: Any] {
        var dict = [String: Any]()
        dict["language"] = language
        dict["loc_id"] = loc_id
        dict["key"] = key
        dict["cmp"] = cmp
        dict["cpc"] = cpc
        dict["sv"] = sv
        dict["categories"] = categories
        var arrMs = [[String: Any]]()
        for info in ms {
            arrMs.append(info.getJson())
        }
        dict["ms"] = arrMs
        
        dict["country_code"] = country_code
        dict["competition"] = competition
        
        dict["score"] = score
        
        return dict
    }
}
