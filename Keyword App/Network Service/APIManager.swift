
import Foundation
import Alamofire

class APIManager {

    public static let apiSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        
        return SessionManager(configuration: configuration)
    }()
    
    class func callAPI(url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, parameterEncoding: ParameterEncoding = URLEncoding.default, success successBlock: @escaping ((Any?, Int?) -> Void), failure failureBlock: ((Error, Int?) -> Bool)?) -> DataRequest {
        
        DLog("parameters = ", parameters ?? [String : Any]())
        DLog("apiURL = ", url)
        
        return Alamofire.request(url, method: method, parameters: parameters, encoding: parameterEncoding, headers: headers)
            .responseString { response in
                DLog("Response String: \(String(describing: response.result.value))")
            }
            .responseJSON { response in
                DLog("Response Error: ", response.result.error)
                DLog("Response JSON: ", response.result.value)
                DLog("response.request: ", response.request?.allHTTPHeaderFields)
                DLog("Response Status Code: ", response.response?.statusCode)
                
                DispatchQueue.main.async {
                    if response.result.error == nil {
                        let responseObject = response.result.value
                        
                        successBlock(responseObject, response.response?.statusCode)
                        
                    } else {
                        if failureBlock != nil && failureBlock!(response.result.error! as NSError, response.response?.statusCode) {
                            if let statusCode = response.response?.statusCode {
                                APIManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                            }
                        }
                    }
                }
            }
    }
    
    class func handleAlamofireHttpFailureError(statusCode: Int) {
        switch statusCode {
        case NSURLErrorNotConnectedToInternet:
            InternetAlertManager.showMessageAlert(title: "Error", andMessage: "An unexpected network error occurred", withOkButtonTitle: "OK")
            
        case NSURLErrorCannotFindHost:
            InternetAlertManager.showMessageAlert(title: "Error", andMessage: "An unexpected network error occurred", withOkButtonTitle: "OK")
        case NSURLErrorCannotParseResponse:
            InternetAlertManager.showMessageAlert(title: "Error", andMessage: "An unexpected network error occurred", withOkButtonTitle: "OK")
        case NSURLErrorUnknown:
            InternetAlertManager.showMessageAlert(title: "Error", andMessage: "Ooops!! Something went wrong, please try after some time!", withOkButtonTitle: "OK")
        case NSURLErrorCancelled:
            break
        case NSURLErrorTimedOut:
            InternetAlertManager.showMessageAlert(title: "Error", andMessage: "The request timed out, please verify your internet connection and try again", withOkButtonTitle: "OK")
        case NSURLErrorNetworkConnectionLost:
            InternetAlertManager.showMessageAlert(title: "Internet", andMessage: "No connection", withOkButtonTitle: "OK")
        default:
            InternetAlertManager.showMessageAlert(title: "Error", andMessage: "An unexpected network error occurred", withOkButtonTitle: "OK")
        }
    }
    
    /*class func callApi(apiURL: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, parameterEncoding: ParameterEncoding, success successBlock:@escaping ((Any?, Int?) -> Void), failure failureBlock: ((Error, Int?) -> Bool)?) -> DataRequest {
        var finalParameters = [String: Any]()
        if parameters != nil {
            finalParameters = parameters!
        }
        
        DLog("parameters = ", finalParameters)
        DLog("apiURL = ", apiURL)
        
        return Alamofire.request(apiURL, method: method, parameters: finalParameters, encoding: parameterEncoding, headers: headers)
            .responseString { response in
                
                DLog("Response String: \(String(describing: response.result.value))")
            }
            .responseJSON { response in
                
                DLog("Response Error: ", response.result.error)
                DLog("Response JSON: ", response.result.value)
                DLog("response.request: ", response.request?.allHTTPHeaderFields)
                DLog("Response Status Code: ", response.response?.statusCode)
                
                DispatchQueue.main.async {
                     if response.result.error == nil {
                        let responseObject = response.result.value
                        
                        if let status = responseObject as? [String : Any], (status["status"] as? String ?? "") == "3" {
                            AppDelegate.shared.logOutFromApplication()
                        }
                        
                        successBlock(responseObject, response.response?.statusCode)
                        
                    } else {
                        if failureBlock != nil && failureBlock!(response.result.error! as NSError, response.response?.statusCode) {
                            if let statusCode = response.response?.statusCode {
                                ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                            }
                        }
                    }
                }
        }
    }*/
}
