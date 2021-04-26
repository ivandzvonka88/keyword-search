
import Foundation
import Firebase
import FirebaseFirestore

class SignupViewModel:BaseViewModel {
    
    // MARK: - Properties
    var email: String!
    var userName: String!
    var password: String!
    var confirmPassword: String!
    
    func validation() -> Bool {
        if email.trimmed().isEmpty {
            errorMessage = "Please enter email id"
        } else if !email.trimmed().isValidEmail {
            errorMessage = "Please enter valid email id"
        } else if userName.isEmpty {
            errorMessage = "Please enter username"
        } else if password.isEmpty {
            errorMessage = "Please enter password"
        } else if confirmPassword.isEmpty {
            errorMessage = "Please enter confirm password"
        } else if password != confirmPassword {
            errorMessage = "Password and confirm password does not match"
        }  else {
            return true
        }
        
        return false
    }
    
    // MARK: - Functions
    func normalSignUp(completion: @escaping(_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email.trimmed(), password: password) { (result, error) in
            if error != nil {
                self.errorMessage = "The email address is already in use by another account."
                completion(false)
                return
            } else {
                let collection = Firestore.firestore().collection(Application.Tables.users)
                
                var user = UserData()
                user.uid = result?.user.uid
                user.username = self.userName
                user.credits = 50
            
                collection.document((result?.user.uid)!).setData(user.dictionary) { (error) in
                    /*if let _ = error {
                        self.errorMessage = "The email address is already in use by another account."
                        completion(false)
                        return
                    }*/
                    
                    let keywordCollection = Firestore.firestore().collection(Application.Tables.savedKeywords)
                    keywordCollection.document((result?.user.uid)!).setData([
                    Application.Tables.keywordField : []]) { (error) in
                        
                        completion(true)
                    }
                    
                    //completion(true)
                }
            }
        }
    }
}
