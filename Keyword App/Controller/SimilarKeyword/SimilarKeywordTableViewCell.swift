
import UIKit

class SimilarKeywordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viwMainContainer: UIView!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblKeyword: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var lblCpc: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgCheckBox.image = imgCheckBox.image?.tintWithColor(#colorLiteral(red: 0.6392156863, green: 0.6392156863, blue: 0.6392156863, alpha: 1))
        imgCheckBox.highlightedImage = imgCheckBox.highlightedImage?.tintWithColor(UIColor(named: "Blue")!)
    }

    func configureEmpty() {
        lblKeyword.text = ""
        lblVolume.text = ""
        lblCpc.text = ""
        lblScore.text = ""
        
        imgCheckBox.isHighlighted = false
        lblKeyword.isHighlighted = false
        lblVolume.isHighlighted = false
        lblCpc.isHighlighted = false
    }
    
    func configure(info: VolumeSearchInfo) {
        lblKeyword.text = info.key
        lblVolume.text = "\(info.sv)"
        lblCpc.text = String(format: "%.2f", info.cpc)
        lblScore.text = String(format: "%.0f", (info.cmp * 100).rounded(.toNearestOrAwayFromZero))//info.score.isEmpty ? "-" : info.score
        lblScore.textColor = (info.cmp * 100).getScoreColor()//info.score.getScoreColor()
        
        imgCheckBox.isHighlighted = info.isSelected
        lblKeyword.isHighlighted = info.isSelected
        lblVolume.isHighlighted = info.isSelected
        lblCpc.isHighlighted = info.isSelected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension String {
    func getScoreColor() -> UIColor {
        if let score = Int(self) {
            if score <= 25 {
                return #colorLiteral(red: 0.5490196078, green: 0.8470588235, blue: 0.9058823529, alpha: 1)
            } else if score > 25 && score <= 50 {
                return #colorLiteral(red: 0, green: 0.5490196078, blue: 0.3725490196, alpha: 1)
            } else if score > 50 && score <= 75 {
                return #colorLiteral(red: 0.9921568627, green: 0.7490196078, blue: 0.2980392157, alpha: 1)
            } else {
                return #colorLiteral(red: 0.9882352941, green: 0.4352941176, blue: 0.4, alpha: 1)
            }
        }
        return .black
    }
}

extension Double {
    func getScoreColor() -> UIColor {
        let score = self.rounded(.toNearestOrAwayFromZero)
        if score <= 25 {
            return #colorLiteral(red: 0.5490196078, green: 0.8470588235, blue: 0.9058823529, alpha: 1)
        } else if score > 25 && score <= 50 {
            return #colorLiteral(red: 0, green: 0.5490196078, blue: 0.3725490196, alpha: 1)
        } else if score > 50 && score <= 75 {
            return #colorLiteral(red: 0.9921568627, green: 0.7490196078, blue: 0.2980392157, alpha: 1)
        } else {
            return #colorLiteral(red: 0.9882352941, green: 0.4352941176, blue: 0.4, alpha: 1)
        }
        return .black
    }
}
