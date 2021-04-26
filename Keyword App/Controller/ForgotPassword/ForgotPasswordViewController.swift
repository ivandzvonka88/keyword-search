
import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var btnSend: UIButton!
    @IBOutlet private weak var txtEmail: SkyFloatingLabelTextField!
    
    // MARK: - Properties
    private var viewModel = ForgotPasswordViewModel()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        
        txtEmail.titleFormatter = { (text: String) -> String in
            return text.capitalized
        }
        
        btnSend.addCornerRadius(btnSend.frame.height / 2)
    }
    
    // MARK: - Actions
    @IBAction func onBtnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func onBtnSend(_ sender: UIButton) {
        view.endEditing(true)
        
        viewModel.email = txtEmail.text!
        
        guard viewModel.validation() else {
            view.showToastAtBottom(message: viewModel.errorMessage)
            return
        }
        
        IndicatorManager.showLoader()
        viewModel.sendForgotPasswordRequest { (isSuccess) in
            IndicatorManager.hideLoader()
            if isSuccess {
                Utility.showMessageAlert(title: "Success!", andMessage: "We have send you an email with instructions on how to reset your password.", withOkButtonTitle: "OK")
                self.dismiss(animated: true, completion: nil)
            } else {
                Utility.showMessageAlert(title: "Error", andMessage: self.viewModel.errorMessage, withOkButtonTitle: "OK")
            }
        }
    }
}
