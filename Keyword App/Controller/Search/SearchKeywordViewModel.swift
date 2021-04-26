
import Foundation
import Charts

class SearchKeywordViewModel: BaseViewModel {
    var currentKeyword = ""
    var keywordDifficultyInfo: KeywordDifficultyInfo!
    var volumeSearchInfo: VolumeSearchInfo!
    
    // MARK: - API calls
    func fetchKeywordDifficultyAndAnalysisData(keyword: String, completion: @escaping (Bool) -> Void) {
        let parameters = ParameterRequest()
        parameters.addKeyForKeysearchAPI()
        //parameters.addParameter(key: ParameterRequest.loc_name_canonical, value: country)
        parameters.addParameter(key: ParameterRequest.difficulty, value: keyword)
        _ = apiClient.fetchKeywordDifficultyAndAnalysisData(parameters: parameters) { (response, error) in
            
            guard error == nil else {
                completion(false)
                return
            }
            
            guard let response = response as? [String : Any] else {
                completion(false)
                return
            }
            self.currentKeyword = keyword
            self.keywordDifficultyInfo = KeywordDifficultyInfo(data: response as! [String : Any])
            completion(true)
        }
    }
    
    func fetchVolumeSearchInfo(keyword: String, completion: @escaping (Bool) -> Void) {
        /*let responseInfo = DataforseoResponse(data: jsonTemplate)
        guard responseInfo.status == "ok" else {
            completion(false)
            return
        }
        
        self.currentKeyword = keyword
        if let results = responseInfo.results as? [[String: Any]] {
            for resultData in results {
                self.volumeSearchInfo = VolumeSearchInfo(data: resultData)
            }
        }
        
        completion(true)
        
        return*/
        
        /*var country = ""
        if !countryList.isEmpty {
            country = countryList[selectedCountryIndex]
        }*/
        
        let parameters = ParameterRequest()
        //parameters.addParameter(key: ParameterRequest.loc_name_canonical, value: country)
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
            
            self.currentKeyword = keyword
            if let results = responseInfo.results as? [[String: Any]] {
                for resultData in results {
                    self.volumeSearchInfo = VolumeSearchInfo(data: resultData)
                }
            }
            
            completion(true)
        }
    }
    
    func getVolumeForChartEntry(entry: ChartDataEntry) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        let date = Date(timeIntervalSince1970: entry.x)
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        for (_, monthInfo) in volumeSearchInfo.ms.enumerated() where monthInfo.year == year && monthInfo.month == month {
            return monthInfo.count
        }
        return 0
    }
}
