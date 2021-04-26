
import UIKit

class ChartLegendCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet weak var imgLegend: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    //MARK: - Outlets
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgLegend.addCornerRadius(imgLegend.frame.size.height/2.0)
    }

    func configure(keyword: String, color: UIColor) {
        lblName.text = keyword
        imgLegend.backgroundColor = color
    }
}
