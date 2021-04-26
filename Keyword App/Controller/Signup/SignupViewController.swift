
import UIKit
import SkyFloatingLabelTextField
import Firebase

class SignupViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var btnAcceptTerms: UIButton!
    @IBOutlet private weak var btnSignup: UIButton!
    @IBOutlet private weak var btnLoginNow: UIButton!
    
    @IBOutlet private weak var btnLoginTitle: UIButton!
    @IBOutlet private weak var btnSignupTitle: UIButton!
    
    @IBOutlet private weak var txtEmailID: SkyFloatingLabelTextField!
    @IBOutlet private weak var txtUserName: SkyFloatingLabelTextField!
    @IBOutlet private weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet private weak var txtConfirmPassword: SkyFloatingLabelTextField!
    
    // MARK: - Properties
    private var handle: AuthStateDidChangeListenerHandle?
    
    private var viewModel = SignupViewModel()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
        handle = Auth.auth().addStateDidChangeListener { _, _ in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: - Methods
    private func setupUI() {
        txtUserName.delegate = self
        
        txtEmailID.titleFormatter = { (text: String) -> String in
            return text.capitalized
        }
        txtUserName.titleFormatter = { (text: String) -> String in
            return text.capitalized
        }
        txtPassword.titleFormatter = { (text: String) -> String in
            return text.capitalized
        }
        txtConfirmPassword.titleFormatter = { (text: String) -> String in
            return text.capitalized
        }
        
        btnSignupTitle.addCornerRadius(btnSignupTitle.frame.height / 2)
        btnSignup.addCornerRadius(btnSignup.frame.height / 2)
    }
    
    // MARK: - Actions
    @IBAction private func onBtnAcceptTerms(_ sender: UIButton) {
        btnAcceptTerms.isSelected = !btnAcceptTerms.isSelected
    }
    
    @IBAction private func onBtnSignup(_ sender: UIButton) {
        impact.prepare()
        impact.impactOccurred()
        view.endEditing(true)
        
        viewModel.email = txtEmailID.text
        viewModel.userName = txtUserName.text
        viewModel.password = txtPassword.text
        viewModel.confirmPassword = txtConfirmPassword.text
        
        guard viewModel.validation() else {
            view.showToastAtBottom(message: viewModel.errorMessage)
            return
        }
        
        /*guard btnAcceptTerms.isSelected else {
            view.showToastAtBottom(message: "Please accept Terms & Service")
            return
        }*/
        
        IndicatorManager.showLoader()
        viewModel.normalSignUp { (isSuccess) in
            IndicatorManager.hideLoader()
            if isSuccess {
                //  Go to home
                AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
                
                self.goToHomeVc()
            } else {
                self.view.showToastAtBottom(message: self.viewModel.errorMessage)
            }
        }
    }
    
    @IBAction private func onBtnLogin(_ sender: UIButton) {
        impact.prepare()
        impact.impactOccurred()
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction private func onBtnLoginNow(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtUserName {
            if (string == " ") {
              return false
            }
        }
        return true
    }
}
