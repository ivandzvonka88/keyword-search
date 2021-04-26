
import UIKit

class FAQViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var tblFAQ: UITableView!
    @IBOutlet weak var lctTblFaqHeight: NSLayoutConstraint!
    
    // MARK: Properties
    var arrFAQ = [
        FAQ(question: "How can I contact you?", answers: [Answer(ans: "Please click \"ContactUs\"")]),
        FAQ(question: "What is CPC?", answers: [Answer(ans: "CPC stands for Cost Per Click")]),
        FAQ(question: "What is Vol?", answers: [Answer(ans: "Vol stands for search volume of the Keyword")]),
        FAQ(question: "How to do keyword research?", answers: [Answer(ans: "Please visit \"How To Research Keywords\"")]),
        FAQ(question: "What is trending?", answers: [Answer(ans: "Please click \"ContactUs\"")]),
    ]

    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        updateTableHeight()
    }

    // MARK: Methods
    private func setupUI() {
        title = "FAQ"
        
        tblFAQ.addCornerRadius(10)
        tblFAQ.applyBorder(1, borderColor: Application.Color.BORDER)
        
        tblFAQ.register(FAQHeaderView.nib, forHeaderFooterViewReuseIdentifier: FAQHeaderView.identifier)
        tblFAQ.delegate = self
        tblFAQ.dataSource = self
        
        setLeftBackItem()
    }
    
    private func updateTableHeight() {
        tblFAQ.layoutIfNeeded()
        lctTblFaqHeight.constant = tblFAQ.contentSize.height
        tblFAQ.layoutIfNeeded()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrFAQ.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let faq = arrFAQ[section]
        
        if faq.isCollapsed {
            return 0
        } else {
            return faq.rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: FAQHeaderView.identifier) as? FAQHeaderView else {
            return nil
        }
        
        let faq = arrFAQ[section]
        cell.faq = faq
        cell.section = section
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FAQTableViewCell.identifier, for: indexPath) as? FAQTableViewCell else { return UITableViewCell() }
        
        let faq = arrFAQ[indexPath.section]
        cell.answer = faq.answers[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: FAQHeaderViewDelegate
extension FAQViewController: FAQHeaderViewDelegate {
    func toggleSection(header: FAQHeaderView, section: Int) {
        
        if section == 4 {
            let trendingVC = TrendingViewController.instantiate(fromAppStoryboard: .Main)
            navigationController?.pushViewController(trendingVC, animated: true)
        } else {
            let faq = arrFAQ[section]
            
            // Toggle collapse
            let collapsed = !faq.isCollapsed
            faq.isCollapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            tblFAQ.reloadData()
            // Adjust the number of the rows inside the section
            /*tblFAQ.beginUpdates()
            tblFAQ.reloadSections([section], with: .fade)
            tblFAQ.endUpdates()*/
        }
        updateTableHeight()
    }
}
