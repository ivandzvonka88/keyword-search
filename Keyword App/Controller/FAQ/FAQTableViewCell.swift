
import UIKit

class FAQTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet private weak var lblAnswer: UILabel!
    
    // MARK: Properties
    var answer: Answer? {
        didSet {
            guard let answer = answer else { return }

            lblAnswer.text = answer.ans
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
