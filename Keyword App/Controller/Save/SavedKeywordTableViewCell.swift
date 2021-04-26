
import UIKit

class SavedKeywordTableViewCell: UITableViewCell {

    @IBOutlet weak var viwMainContainer: UIView!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblKeyword: UILabel!
    @IBOutlet weak var btnPieChart: UIButton!
    @IBOutlet weak var btnLineChart: UIButton!
    @IBOutlet weak var btnLink: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgCheckBox.image = imgCheckBox.image?.tintWithColor(#colorLiteral(red: 0.6392156863, green: 0.6392156863, blue: 0.6392156863, alpha: 1))
        imgCheckBox.highlightedImage = imgCheckBox.highlightedImage?.tintWithColor(UIColor(named: "Blue")!)
        
        let borderWidth: CGFloat = 1.0
        let borderColor = #colorLiteral(red: 0.6588235294, green: 0.6666666667, blue: 0.6941176471, alpha: 1)
        btnPieChart.applyBorder(borderWidth, borderColor: borderColor)
        btnLineChart.applyBorder(borderWidth, borderColor: borderColor)
        btnLink.applyBorder(borderWidth, borderColor: borderColor)
    }

    func confugureEmpty() {
        lblKeyword.text = " "
        
        imgCheckBox.isHighlighted = false
        lblKeyword.isHighlighted = false
        
        btnPieChart.isHidden = true
        btnLineChart.isHidden = true
        btnLink.isHidden = true
    }
    
    func configure(info: VolumeSearchInfo) {
        lblKeyword.text = info.key
        
        imgCheckBox.isHighlighted = info.isSelected
        lblKeyword.isHighlighted = info.isSelected
        
        btnPieChart.isHidden = false
        btnLineChart.isHidden = false
        btnLink.isHidden = false
    }
    
    func configure(info: SavedKeywordInfo) {
        lblKeyword.text = info.keyword
        
        imgCheckBox.isHighlighted = info.isSelected
        lblKeyword.isHighlighted = info.isSelected
        
        btnPieChart.isHidden = false
        btnLineChart.isHidden = false
        btnLink.isHidden = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
