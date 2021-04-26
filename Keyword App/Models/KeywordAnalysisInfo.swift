
import Foundation

class KeywordAnalysisInfo {
    var url: String
    var pa: String
    var da: String
    var rankurl: String
    var rankdom: String
    var authlinks: String
    var links: String
    var titlematch: String
    var descmatch: String
    var linkmatch: String
    
    init(data: [String: Any]) {
        url = data["url"] as? String ?? ""
        pa = data["PA"] as? String ?? "0"
        da = data["DA"] as? String ?? "0"
        rankurl = data["rankurl"] as? String ?? "0"
        rankdom = data["rankdom"] as? String ?? "0"
        authlinks = data["authlinks"] as? String ?? "0"
        links = data["links"] as? String ?? "0"
        titlematch = data["titlematch"] as? String ?? ""
        descmatch = data["descmatch"] as? String ?? ""
        linkmatch = data["linkmatch"] as? String ?? ""
        
        pa = self.getStringFrom(value: data["PA"]) ?? "0"
        da = self.getStringFrom(value: data["DA"]) ?? "0"
        rankurl = self.getStringFrom(value: data["rankurl"]) ?? "0"
        rankdom = self.getStringFrom(value: data["rankdom"]) ?? "0"
        authlinks = self.getStringFrom(value: data["authlinks"]) ?? "0"
        links = self.getStringFrom(value: data["links"]) ?? "0"
    }
    
    private func getStringFrom(value: Any?) -> String? {
        if let val = value as? Int {
            return "\(val)"
        } else if let val = value as? Double {
            return "\(val)"
        } else if let val = value as? String {
            return val
        }
        return nil
    }
}
