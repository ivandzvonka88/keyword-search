
import Foundation
import Charts

class TrendViewModel: BaseViewModel {
    var arrKeywords = [String]()
    var arVolumeSearchInfo = [VolumeSearchInfo]()
    var countryList = [String]()
    var selectedCountryIndex = 0
    var arrSelectedMonthIndex = [Int]()
    
    // MARK: - API calls
    func fetchVolumeSearchInfo(keyword: String, refresh: Bool = false, completion: @escaping (Bool) -> Void) {
        if !refresh {
            for key in arrKeywords where key.lowercased() == keyword {
                completion(false)
                return
            }
        }
        /*arrKeywords.append("software")
        arrKeywords.append("planet")
        let responseInfo = DataforseoResponse(data: jsonTemplate)
        guard responseInfo.status == "ok" else {
            completion(false)
            return
        }
        if let results = responseInfo.results as? [[String: Any]] {
            for resultData in results {
                self.arVolumeSearchInfo.append(VolumeSearchInfo(data: resultData))
                //completion(true)
            }
        }
        
        let responseInfo1 = DataforseoResponse(data: jsonTemplate1)
        guard responseInfo1.status == "ok" else {
            completion(false)
            return
        }
        if let results = responseInfo1.results as? [[String: Any]] {
            for resultData in results {
                self.arVolumeSearchInfo.append(VolumeSearchInfo(data: resultData))
            }
        }
        
        completion(true)
        
        return*/
        
        var country = ""
        if !countryList.isEmpty {
            country = countryList[selectedCountryIndex]
        }
        
        let parameters = ParameterRequest()
        parameters.addParameter(key: ParameterRequest.loc_name_canonical, value: country)
        parameters.addParameter(key: ParameterRequest.key, value: keyword)
        _ = apiClient.fetchSearchVolumeData(parameters: parameters) { (response, error) in
            
            guard error == nil else {
                completion(false)
                return
            }
            
            guard let response = response else {
                completion(false)
                return
            }
            
            let responseInfo = DataforseoResponse(data: response as! [String : Any])
            guard responseInfo.status == "ok" else {
                completion(false)
                return
            }
            
            if !refresh {
                self.arrKeywords.append(keyword)
            }
            
            if let results = responseInfo.results as? [[String: Any]] {
                for resultData in results {
                    self.arVolumeSearchInfo.append(VolumeSearchInfo(data: resultData))
                }
            }
            
            if refresh {
                completion(true)
            } else {
                self.fetchKeywordDifficultyScore(keyword: keyword) { (score, success) in
                    self.arVolumeSearchInfo.last?.score = score
                    completion(true)
                }
            }
        }
    }
    
    func fetchKeywordDifficultyScore(keyword: String, completion: @escaping (String, Bool) -> Void) {
        let parameters = ParameterRequest()
        parameters.addKeyForKeysearchAPI()
        //parameters.addParameter(key: ParameterRequest.loc_name_canonical, value: country)
        parameters.addParameter(key: ParameterRequest.difficulty, value: keyword)
        _ = apiClient.fetchKeywordDifficultyAndAnalysisData(parameters: parameters) { (response, error) in
            
            guard error == nil else {
                completion("", false)
                return
            }
            
            guard let response = response else {
                completion("", false)
                return
            }
            
            if let responseData = response as?  [String : Any] {
                let keywordDifficultyInfo = KeywordDifficultyInfo(data: responseData)
                completion(keywordDifficultyInfo.score, true)
            } else {
                completion("", true)
            }
        }
    }
    
    func fetchScoreForAllKeywords(completion: @escaping () -> Void) {
        guard !arVolumeSearchInfo.isEmpty else {
            completion()
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let waitGroup = DispatchGroup()
            
            for keywordInfo in self.arVolumeSearchInfo {
                waitGroup.enter()
                self.fetchKeywordDifficultyScore(keyword: keywordInfo.key) { (score, success) in
                    keywordInfo.score = score
                    waitGroup.leave()
                }
                waitGroup.wait()
            }
            
            waitGroup.notify(queue: .main) {
                print("Finished all requests.")
                completion()
            }
        }
    }
    
    //MARK: - Functions
    func generateCountryListForPicker() {
        if countryList.isEmpty && !arCountry.isEmpty {
            countryList.append("")
            for info in arCountry {
                countryList.append(info.loc_name_canonical)
            }
        }
    }
    
    func refreshSelectedMonthArray(entry: ChartDataEntry) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        let date = Date(timeIntervalSince1970: entry.x)
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        arrSelectedMonthIndex.removeAll()
        for searchInfo in arVolumeSearchInfo {
            for (index, monthInfo) in searchInfo.ms.enumerated() where monthInfo.year == year && monthInfo.month == month {
                arrSelectedMonthIndex.append(index)
                break
            }
        }
    }
}
