
import UIKit

class KeywordAnalysisTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viwMainContainer: UIView!
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblPa: UILabel!
    @IBOutlet weak var lblDa: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureEmpty() {
        lblUrl.text = " "
        lblPa.text = " "
        lblDa.text = " "
    }

    func configure(info: KeywordAnalysisInfo) {
        lblUrl.text = info.url
        lblPa.text = "\(info.pa)"
        lblDa.text = "\(info.da)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
