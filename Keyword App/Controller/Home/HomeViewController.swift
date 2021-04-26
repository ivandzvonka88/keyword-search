
import UIKit
import MessageUI

class HomeViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet private var viwBtnContainer: [UIView]!
    @IBOutlet private weak var viwLearnMoreContainer: UIView!

    //MARK: - Properties
    private var viewModel = HomeViewModel()
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.arCountry.isEmpty {
            viewModel.fetchKeywordLocations { (success) in
            }
        }
        
        setupBalanceViewRightItem()
    }

    // MARK: Methods
    private func setupUI() {
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_logout"), style: .plain, target: self, action: #selector(onBtnLogout))
        setupLogoutButton()
        
        viwBtnContainer.forEach { viw in
            viw.addCornerRadius(10)
            viw.applyBorder(1, borderColor: Application.Color.BORDER)
        }
        
        viwLearnMoreContainer.addCornerRadius(10)
        viwLearnMoreContainer.applyBorder(1, borderColor: Application.Color.BORDER)
    }
    
    private func setupLogoutButton() {
        let logoutButtonView = LogoutButtonView.constructView(owner: self)
        logoutButtonView.addCornerRadius(15)
        logoutButtonView.btnLogout.addTarget(self, action: #selector(onBtnLogout), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: logoutButtonView)
        navigationItem.leftBarButtonItem = leftItem
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    // MARK: Actions
    @IBAction private func onBtnSearchVolume(_ sender: UIButton) {
        let searchVC = SearchViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction private func onBtnTrend(_ sender: UIButton) {
        let trendVC = TrendViewController.instantiate(fromAppStoryboard: .Main)
        trendVC.viewModel.arCountry = viewModel.arCountry
        navigationController?.pushViewController(trendVC, animated: true)
    }
    
    @IBAction private func onBtnSimilarKeyword(_ sender: UIButton) {
        let similarVC = SimilarKeywordsViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(similarVC, animated: true)
    }
    
    @IBAction private func onBtnSaved(_ sender: UIButton) {
        let saveVC = SavedKeywordViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(saveVC, animated: true)
    }

    @IBAction private func onBtnContactUs(_ sender: UIButton) {
        let recipientEmail = "contact@keywordplus.ca"
        let subject = "Contact: Keyword Plus"
        let body = ""
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        } else {
            Utility.showMessageAlert(title: "Error", andMessage: "Email not configured on your device.", withOkButtonTitle: "OK")
        }
    }
    
    @IBAction private func onBtnFAQ(_ sender: UIButton) {
        let faqVC = FAQViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(faqVC, animated: true)
    }
    
    @IBAction private func onbtnHowToResearchKeyword(_ sender: UIButton) {
        let researchVC = ResearchViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(researchVC, animated: true)
    }
    @IBAction func onBtnBuyCredits(_ sender: Any) {
        let buyVc = BuyCreditsViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(buyVc, animated: true)
    }
    
    @objc private func onBtnLogout() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.viewModel.stopListeningCreditBalance()
            self.logOutFromApplication()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: MFMailComposeViewControllerDelegate
extension HomeViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
