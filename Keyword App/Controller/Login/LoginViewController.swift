
import UIKit
import SkyFloatingLabelTextField
import Firebase

class LoginViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var btnForgotPassword: UIButton!
    @IBOutlet private weak var btnLogin: UIButton!
    @IBOutlet private weak var btnRegisterNow: UIButton!
    
    @IBOutlet private weak var btnLoginTitle: UIButton!
    @IBOutlet private weak var btnSignupTitle: UIButton!
    
    @IBOutlet private weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet private weak var txtPassword: SkyFloatingLabelTextField!
    
    // MARK: - Properties
    private var viewModel = LoginViewModel()
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        handle = Auth.auth().addStateDidChangeListener { _, _ in
//        }
        
        if AppPrefsManager.shared.isUserLogin() {
            goToHomeVc()
        } else {        // Without sign-out user uninstall app then sign-out otherwise data will update
            do {
                try Auth.auth().signOut()
            } catch {
                DLog("Error while logout!")
            }
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: - Methods
    private func setupUI() {
        
        txtEmail.titleFormatter = { (text: String) -> String in
            return text.capitalized
        }
        txtPassword.titleFormatter = { (text: String) -> String in
            return text.capitalized
        }
        
        btnLoginTitle.addCornerRadius(btnLoginTitle.frame.height / 2)
        btnLogin.addCornerRadius(btnLogin.frame.height / 2)
    }
    
    // MARK: - Actions
    @IBAction private func onBtnForgotPassword(_ sender: UIButton) {
        let nextVc = ForgotPasswordViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.present(nextVc, animated: true, completion: nil)
    }
    
    @IBAction private func onBtnLogin(_ sender: UIButton) {
        impact.prepare()
        impact.impactOccurred()
        view.endEditing(true)
        
        viewModel.email = txtEmail.text!
        viewModel.password = txtPassword.text!
        
        guard viewModel.validation() else {
            view.showToastAtBottom(message: viewModel.errorMessage)
            return
        }
        
        IndicatorManager.showLoader()
        viewModel.normalSignIn { (isSuccess) in
            IndicatorManager.hideLoader()
            if isSuccess {
                AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
                self.goToHomeVc()
            } else {
                self.view.showToastAtBottom(message: self.viewModel.errorMessage)
            }
        }
    }
    
    @IBAction private func onBtnSignup(_ sender: UIButton) {
        impact.prepare()
        impact.impactOccurred()
        let nextVc = SignupViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(nextVc, animated: false)
    }
    
    @IBAction private func onBtnRegisterNow(_ sender: UIButton) {
        let nextVc = SignupViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(nextVc, animated: false)
    }
}
