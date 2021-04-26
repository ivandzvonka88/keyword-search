
import Foundation
import Firebase
import FirebaseFirestore

class LoginViewModel: BaseViewModel {
    
    // MARK: - Properties
    var email: String!
    var password: String!
    
    func validation() -> Bool {
        if email.isEmpty {
            errorMessage = "Please enter email"
        } else if !email.isValidEmail {
            errorMessage = "Please enter valid email"
        } else if password.isEmpty {
            errorMessage = "Please enter password"
        } else {
            return true
        }
        
        return false
    }
    
    // MARK: - Functions
    func normalSignIn(completion: @escaping(_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorMessage = "Invalid email or password"
                completion(false)
                return
            }
            
            if let data = result?.user {
                data.getIDToken(completion: { (token, error) in
                    print("Token: ", token!)
                    
                    // This for user data fount after login
                    /*let collection = Firestore.firestore().collection(Application.Tables.users).document((result?.user.uid)!)
                    
                    collection.getDocument { (querySnapshot, error) in
                        guard let snapshot = querySnapshot else {
                            self.errorMessage = "Invalid username or password"
                            completion(false)
                            return
                        }
                        
//                        let data = UserData(dic: snapshot.data()!)
//                        AppPrefsManager.shared.setUserResulModel(model: data)
                        
                        completion(true)
                    }*/
                    
                    completion(true)
                })
            } else {
                self.errorMessage = "Invalid email or password"
                completion(false)
                return
            }
        }
    }
}
