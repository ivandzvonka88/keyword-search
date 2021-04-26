
import UIKit
import Firebase
import FirebaseFirestore

class BaseViewController: UIViewController {

    var creditBalanceView: CreditBalanceView!
    
    private var baseViewModel = BaseViewModel()
    lazy var impact = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: Methods
    func setLeftBackItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(onBtnBack(_:)))
    }
    
    func setupBalanceViewRightItem() {
        if creditBalanceView == nil {
            creditBalanceView = CreditBalanceView.constructView(owner: self)
            creditBalanceView.lblBalance.text =  String(AppDelegate.shared.creditBalance)
        }
        
        creditBalanceView.btnCreditBalance.addTarget(self, action: #selector(onBtnCreditBalance(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: creditBalanceView)
        navigationItem.rightBarButtonItem = rightItem
    }

    func goToHomeVc() {
        let rootVc = HomeViewController.instantiate(fromAppStoryboard: .Main)
        let navVc = UINavigationController(rootViewController: rootVc)
        AppDelegate.shared.window?.rootViewController = navVc
    }
    
    func logOutFromApplication() {
        do {
            try Auth.auth().signOut()
            
            AppPrefsManager.shared.setIsUserLogin(isUserLogin: false)
            
            AppDelegate.shared.window?.rootViewController = UINavigationController(rootViewController: LoginViewController.instantiate(fromAppStoryboard: .Main))
        } catch {
            DLog("Error while logout!")
        }
    }
    
    // MARK: Actions
    @objc func onBtnBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBtnCreditBalance(_ sender: UIButton) {
        let nextVc = BuyCreditsViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(nextVc, animated: true)
    }
}
