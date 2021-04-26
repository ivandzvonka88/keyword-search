
import Foundation
import FirebaseFirestore
import Firebase

class SimilarKeywordsViewModel: BaseViewModel {
    var arrSimilarKeywords = [VolumeSearchInfo]()
    var currentKeyword = ""
    
    // MARK: - API calls
    func fetchSimilarKeywords(keyword: String, completion: @escaping (Bool) -> Void) {
        
        /*let responseInfo = DataforseoResponse(data: jsonTemplate2)
        guard responseInfo.status == "ok" else {
            completion(false)
            return
        }
        
        if let results = responseInfo.results as? [[String: Any]] {
            for resultData in results {
                self.arrSimilarKeywords.append(VolumeSearchInfo(data: resultData))
            }
        }
        completion(true)
        return*/
        
        let parameters = ParameterRequest()
        //parameters.addParameter(key: ParameterRequest.country_code, value: "US")
        //parameters.addParameter(key: ParameterRequest.keywords, value: [keyword])
        parameters.addParameter(key: ParameterRequest.keys, value: [keyword])
        parameters.addParameter(key: ParameterRequest.language, value: "")
        parameters.addParameter(key: ParameterRequest.loc_name_canonical, value: "")
        //parameters.addParameter(key: ParameterRequest.limit, value: 30)
        
//        let uniqueId = Int.random(in: 0...30000000)
//        let finalParameters = ParameterRequest()
//        finalParameters.addParameter(key: "\(uniqueId)", value: parameters.parameters)
        _ = apiClient.fetchSimilarKeywordsData(parameters: parameters) { (response, error) in
            
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
            self.arrSimilarKeywords.removeAll()
//            if let results = responseInfo.results as? [String: Any] {
//                if let keywordData = results["\(uniqueId)"] as? [String: Any] {
//                    if let keywordResults = keywordData["result"] as? [[String: Any]] {
//                        for resultData in keywordResults {
//                            self.arrSimilarKeywords.append(VolumeSearchInfo(data: resultData))
//                        }
//                    }
//                }
//            }
            if let results = responseInfo.results as? [[String: Any]] {
                for resultData in results {
                    self.arrSimilarKeywords.append(VolumeSearchInfo(data: resultData))
                }
            }
//            for resultData in responseInfo.results {
//                self.arrSimilarKeywords.append(VolumeSearchInfo(data: resultData))
//            }
            completion(true)
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
        guard !arrSimilarKeywords.isEmpty else {
            completion()
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let waitGroup = DispatchGroup()
            
            for keywordInfo in self.arrSimilarKeywords {
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
    
    func saveKeywords(keywords: [Any], completion: @escaping (Bool) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let collection = Firestore.firestore().collection(Application.Tables.savedKeywords).document(uid)
            
            collection.updateData([Application.Tables.keywordField : FieldValue.arrayUnion(keywords)]) { (error) in
                if let err = error {
                    DLog("Error add object value to document: \(err)")
                    completion(false)
                } else {
                    DLog("Add object value to document successfully.")
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }
    
    func setSavedKeywords(keywords: [Any], completion: @escaping (Bool) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let collection = Firestore.firestore().collection(Application.Tables.savedKeywords).document(uid)
            
            collection.setData([
                Application.Tables.keywordField : keywords]) { (error) in
                    if let err = error {
                        DLog("Error create object value to document: \(err)")
                        completion(false)
                    } else {
                        DLog("create object value to document successfully.")
                        completion(true)
                    }
            }
        } else {
            completion(false)
        }
    }
}
