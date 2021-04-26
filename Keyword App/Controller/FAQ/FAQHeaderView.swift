
import UIKit

protocol FAQHeaderViewDelegate: AnyObject {
    func toggleSection(header: FAQHeaderView, section: Int)
}

class FAQHeaderView: UITableViewHeaderFooterView {
    
    // MARK: IBOutlets
    @IBOutlet private weak var lblQuestions: UILabel!
    @IBOutlet private weak var imgArrow: UIImageView!
    @IBOutlet private weak var viwMainContainer: UIView!
    
    // MARK: Properties
    var section: Int = 0
    weak var delegate: FAQHeaderViewDelegate?
    
    var faq: FAQ? {
        didSet {
            guard let faq = faq else { return }
            lblQuestions.text = faq.question
            setCollapsed(collapsed: faq.isCollapsed)
        }
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }

    // MARK: Methods
    func setCollapsed(collapsed: Bool) {
        imgArrow.rotate(collapsed ? 0.0 : .pi / -2)
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
}
