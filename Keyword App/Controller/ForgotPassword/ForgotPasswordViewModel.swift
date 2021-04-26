
import Foundation
import Firebase
import FirebaseFirestore

class ForgotPasswordViewModel: BaseViewModel {
    
    // MARK: - Properties
    var email: String!
    
    func validation() -> Bool {
        if email.isEmpty {
            errorMessage = "Please enter email"
        } else if !email.isValidEmail {
            errorMessage = "Please enter valid email"
        } else {
            return true
        }
        
        return false
    }
    
    // MARK: - Functions
    func sendForgotPasswordRequest(completion: @escaping(_ success: Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                self.errorMessage = error?.localizedDescription ?? "Forgot password request failed. Please try again later."
                completion(false)
                return
            }
            completion(true)
        }
    }
}
