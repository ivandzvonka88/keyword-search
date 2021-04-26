
import Foundation

class KeywordDifficultyInfo {
    var id: String
    var keyword: String
    var location: String
    var cpc: String
    var ppc: String
    var volume: String
    var score: String
    var json_result: String
    
    var analysisResults = [KeywordAnalysisInfo]()
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        keyword = data["keyword"] as? String ?? ""
        location = data["location"] as? String ?? ""
        cpc = data["cpc"] as? String ?? "0"
        ppc = data["ppc"] as? String ?? "0"
        volume = data["volume"] as? String ?? "0"
        score = data["score"] as? String ?? "0"
        json_result = data["json_result"] as? String ?? ""
        
        analysisResults.removeAll()
        if let jsonArray = json_result.toJsonArray() {
            for json in jsonArray {
                analysisResults.append(KeywordAnalysisInfo(data: json))
            }
        }
        
        cpc = self.getStringFrom(value: data["cpc"]) ?? "0"
        ppc = self.getStringFrom(value: data["ppc"]) ?? "0"
        volume = self.getStringFrom(value: data["volume"]) ?? "0"
        score = self.getStringFrom(value: data["score"]) ?? "0"
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
