
import Foundation
import FirebaseFirestore
import Firebase

class SavedKeywordViewModel: BaseViewModel {
    //var arrSavedKeywords = [VolumeSearchInfo]()
    var arrSavedKeywords = [SavedKeywordInfo]()
    
    func fetchSavedKeywords(completion: @escaping () -> Void) {
        arrSavedKeywords.removeAll()
        //arrSavedKeywords.append(contentsOf: LocalPreferenceManager.shared.arrVolumeSearchInfo)
        if let uid = Auth.auth().currentUser?.uid {
            let collection = Firestore.firestore().collection(Application.Tables.savedKeywords).document(uid)
            collection.getDocument { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    completion()
                    return
                }
                
                let data = snapshot.data()
                if let keywords = data?[Application.Tables.keywordField] as? [String] {
                    for key in keywords {
                        let info = SavedKeywordInfo()
                        info.keyword = key
                        self.arrSavedKeywords.append(info)
                    }
                }
                
                completion()
            }
        } else {
            completion()
        }
    }
    
    // MARK: - Fire store
    func updateSavedKeywords(keywords: [Any], completion: @escaping (Bool) -> Void) {
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
    
    func removeKeywords(keywords: [Any], completion: @escaping (Bool) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let collection = Firestore.firestore().collection(Application.Tables.savedKeywords).document(uid)
            
            collection.updateData([Application.Tables.keywordField : FieldValue.arrayRemove(keywords)]) { (error) in
                if let err = error {
                    DLog("Error remove object value to document: \(err)")
                    completion(false)
                } else {
                    DLog("Remove object value to document successfully.")
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }
}
