
import UIKit

class TrendTableViewCell: UITableViewCell {

    @IBOutlet weak var viwMainContainer: UIView!
    @IBOutlet weak var imgColor: UIImageView!
    @IBOutlet weak var lblKeyword: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var lblCpc: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgColor.addCornerRadius(imgColor.frame.size.height/2.0)
    }

    func configure(info: VolumeSearchInfo, monthInfoIndex: Int, color: UIColor) {
        lblKeyword.text = info.key
        lblVolume.text = "\(info.ms[monthInfoIndex].count)"//"\(info.sv)"
        lblCpc.text = String(format: "%.2f", info.cpc)//"\(info.cpc)"
        lblScore.text = String(format: "%.0f", (info.cmp * 100).rounded(.toNearestOrAwayFromZero))//info.score.isEmpty ? "-" : info.score
        imgColor.backgroundColor = color
    }
    
}
