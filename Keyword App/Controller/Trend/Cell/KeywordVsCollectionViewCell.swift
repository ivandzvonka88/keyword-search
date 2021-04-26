
import UIKit

class KeywordVsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainerMain: UIView!
    @IBOutlet weak var lblKeyword: UILabel!
    @IBOutlet weak var viewContainerVs: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainerMain.addCornerRadius(3.0)
    }

    func configure(keyword: String, color: UIColor) {
        lblKeyword.text = keyword
        lblKeyword.textColor = color
        viewContainerMain.backgroundColor = color.withAlphaComponent(0.2)
    }
    
}
