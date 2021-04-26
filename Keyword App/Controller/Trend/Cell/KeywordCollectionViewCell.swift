
import UIKit

class KeywordCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainerMain: UIView!
    @IBOutlet weak var lblKeyword: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainerMain.addCornerRadius(15)
    }
    
    func configure(keyword: String, color: UIColor) {
        lblKeyword.text = keyword
        lblKeyword.textColor = color
        viewContainerMain.backgroundColor = color.withAlphaComponent(0.1)
        btnRemove.setImage(btnRemove.currentImage?.tintWithColor(color), for: .normal)
    }

    /*override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }*/
}
