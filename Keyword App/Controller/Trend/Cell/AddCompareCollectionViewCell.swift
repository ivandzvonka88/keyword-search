
import UIKit
import PMSuperButton

class AddCompareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainerMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAdd: PMSuperButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.contentView.layer.masksToBounds = false
        viewContainerMain.addCornerRadius(15.0)
        viewContainerMain.addShadow(color: UIColor(named: "Light Blue")!, opacity: 0.6, offset: CGSize(width: 0, height: 1), radius: 10)
        /*btnAdd.setBackgroundImage(btnAdd.backgroundImage(for: .normal)?.tintWithColor(UIColor(named: "Light Blue")!), for: .highlighted)
        btnAdd.setBackgroundImage(btnAdd.backgroundImage(for: .normal)?.tintWithColor(UIColor(named: "Light Blue")!), for: .selected)
        btnAdd.setBackgroundImage(btnAdd.backgroundImage(for: .normal)?.tintWithColor(UIColor(named: "Light Blue")!), for: .reserved)*/
    }

}
