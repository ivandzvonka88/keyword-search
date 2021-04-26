
import Foundation
import Firebase
import FirebaseFirestore

class HomeViewModel: BaseViewModel {
    
    var creditListener: ListenerRegistration?
    
    override init() {
        super.init()
        startListeningCreditBalance()
    }
    
    func startListeningCreditBalance() {
        if let uid = Auth.auth().currentUser?.uid {
            let collection = Firestore.firestore().collection(Application.Tables.users).document(uid)
            creditListener = collection.addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    DLog("Error fetching document: \(error!)")
                    return
                }
                
                let data = document.data()
                let credit = data?["credits"] as? Int ?? 0
                AppDelegate.shared.creditBalance = credit
                NotificationCenter.default.post(name: .updateCreditBalance, object: credit)
            }
        }
    }
    
    func stopListeningCreditBalance() {
        creditListener?.remove()
    }
}
