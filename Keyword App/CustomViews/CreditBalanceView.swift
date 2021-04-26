
import UIKit

class CreditBalanceView: UIView {

    @IBOutlet weak var viewContainerBalance: UIView!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnCreditBalance: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addNotificationObserver()
        viewContainerBalance.addCornerRadius(5)
    }
    
    class func constructView(owner: Any?) -> CreditBalanceView {
        let nib = UINib(nibName: "CreditBalanceView", bundle: nil)
        let view = nib.instantiate(withOwner: owner, options: nil)[0] as! CreditBalanceView
        return view
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateCreditBalanceNotification(notification:)), name: .updateCreditBalance, object: nil)
    }
    
    @objc private func onUpdateCreditBalanceNotification(notification: Notification) {
        if let credit = notification.object as? Int {
            lblBalance.text = String(credit)
        }
    }
}
