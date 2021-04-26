
import UIKit

class LogoutButtonView: UIView {

    @IBOutlet weak var btnLogout: UIButton!
    
    class func constructView(owner: Any?) -> LogoutButtonView {
        let nib = UINib(nibName: "LogoutButtonView", bundle: nil)
        let view = nib.instantiate(withOwner: owner, options: nil)[0] as! LogoutButtonView
        return view
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
