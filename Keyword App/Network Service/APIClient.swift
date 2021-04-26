
import Alamofire
import Foundation

class APIClient {
    private func callAPI(url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, parameterEncoding: ParameterEncoding = URLEncoding.default, completion completionBlock: @escaping (Any?, Error?) -> Void) -> DataRequest {
        return APIManager.callAPI(url: url, method: method, parameters: parameters, headers: headers, parameterEncoding: parameterEncoding,
                                  success: { response, _ in
                                      DispatchQueue.main.async {
                                          completionBlock(response, nil)
                                      }
                                  },
                                  failure: { (error, status) -> Bool in
                                    DLog(error, status)
                                    DispatchQueue.main.async {
                                        completionBlock(nil, error)
                                    }
                                      return true
                                    }
        )
    }
    
    func fetchKeywordDifficultyAndAnalysisData(parameters: ParameterRequest, completion completionBlock: @escaping ( Any?, Error?) -> Void) -> DataRequest {
        return callAPI(url: API.KEYSEARCH_BASE_URL, method: .get, parameters: parameters.parameters, headers: nil, completion: completionBlock)
    }
    
    func fetchKeywordLocations(completion completionBlock: @escaping ( Any?, Error?) -> Void) -> DataRequest {
        let headerRequest = HeaderRequestParameter()
        headerRequest.addAuthorizationForDataforseo()
        
        return callAPI(url: API.KEYWORD_LOCATIONS, method: .get, parameters: nil, headers: headerRequest.parameters, completion: completionBlock)
    }
    
    func fetchSearchVolumeData(parameters: ParameterRequest, completion completionBlock: @escaping ( Any?, Error?) -> Void) -> DataRequest {
        let finalParameters = ParameterRequest()
        finalParameters.addParameter(key: "data", value: [parameters.parameters])
        
        let headerRequest = HeaderRequestParameter()
        headerRequest.addAuthorizationForDataforseo()
        
        return callAPI(url: API.SEARCH_VOLUME, method: .post, parameters: finalParameters.parameters, headers: headerRequest.parameters, parameterEncoding: JSONEncoding.default, completion: completionBlock)
    }
    
    func fetchSimilarKeywordsData(parameters: ParameterRequest, completion completionBlock: @escaping ( Any?, Error?) -> Void) -> DataRequest {
        let finalParameters = ParameterRequest()
        finalParameters.addParameter(key: "data", value: [parameters.parameters])
        
        let headerRequest = HeaderRequestParameter()
        headerRequest.addAuthorizationForDataforseo()
        
        return callAPI(url: API.KEYWORDS_FOR_KEYWORDS, method: .post, parameters: finalParameters.parameters, headers: headerRequest.parameters, parameterEncoding: JSONEncoding.default, completion: completionBlock)
    }
}
