
import Foundation
import Firebase
import FirebaseFirestore

struct ApiCredit {
    static let volumeSearch       =   3
    static let trend              =   3
    static let similarKeywords    =   10
}

class BaseViewModel {
    
    // MARK: Properties
    var apiClient = APIClient()
    var errorMessage = ""
    
    var arCountry = [KeywordLocationInfo]()
    
    // MARK: - API calls
    func getCreditsScore(completion: @escaping (_ credit: Int, _ success: Bool) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let collection = Firestore.firestore().collection(Application.Tables.users).document(uid)
            
            collection.getDocument { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    DLog("User data not found")
                    completion(0, false)
                    return
                }
                
                let data = snapshot.data()
                let credit = data?["credits"] as? Int ?? 0
                
                completion(credit, true)
            }
        } else {
            completion(0, false)
        }
    }
    
    func setCreditsScore(newCreditValue: Int, completion: @escaping (_ updatedValue: Int, _ success: Bool) -> Void) {
        getCreditsScore { (credit, success) in
            guard success else {
                completion(0, false)
                return
            }
            let credit = credit + newCreditValue
            if let uid = Auth.auth().currentUser?.uid {
                let collection = Firestore.firestore().collection(Application.Tables.users).document(uid)
                
                collection.updateData(["credits": credit]) { (error) in
                    if let err = error {
                        completion(credit, false)       // If fail then show old value
                        DLog("Error updating document: \(err)")
                    } else {
                        completion(credit, true)
                        DLog("Document successfully updated")
                    }
                }
            } else {
                completion(credit, false)
            }
        }
    }
    
    /*func setCreditsScore(newCreditValue: Int) {
        if let uid = Auth.auth().currentUser?.uid {
            let collection = Firestore.firestore().collection(Application.Tables.users).document(uid)
            
            collection.updateData(["credits": newCreditValue]) { (error) in
                if let err = error {
                    DLog("Error updating document: \(err)")
                } else {
                    DLog("Document successfully updated")
                }
            }
        }
    }*/
    
    func fetchKeywordLocations(completion: @escaping (Bool) -> Void) {
        _ = apiClient.fetchKeywordLocations() { (response, error) in
            
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
            
            if let results = responseInfo.results as? [[String: Any]] {
                for resultData in results {
                    self.arCountry.append(KeywordLocationInfo(data: resultData))
                }
                LocalPreferenceManager.shared.saveCountries(arrCountryData: results)
            }
            
            completion(true)
        }
    }
}
