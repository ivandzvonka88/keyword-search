
import UIKit
import IQKeyboardManagerSwift

class SimilarKeywordsViewController: BaseViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var tblKeyword: UITableView!
    @IBOutlet private weak var txtSearch: UITextField!
    //@IBOutlet private weak var lctTblHeight: NSLayoutConstraint!
    @IBOutlet private weak var lblKeyword: UILabel!
    @IBOutlet private weak var lblSearchDesc: UILabel!
    @IBOutlet private weak var viwTblContainer: UIView!
    @IBOutlet private weak var viwKeywordContainer: UIView!
    @IBOutlet private weak var btnSave: UIButton!
    
    //MARK: - Properties
    var viewModel = SimilarKeywordsViewModel()
    var fromSavedKeywordScreen = false
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tblKeyword.layoutIfNeeded()
        //lctTblHeight.constant = tblKeyword.contentSize.height
        viwTblContainer.layoutIfNeeded()
        if fromSavedKeywordScreen {
            txtSearch.text = viewModel.currentKeyword
            fetchSimilarKeywords(keyword: txtSearch.text!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBalanceViewRightItem()
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: Methods
    private func setupUI() {
        title = "Similar Keyword"
        
        tblKeyword.delegate = self
        tblKeyword.dataSource = self
        
        txtSearch.delegate = self
        txtSearch.addLeftPadding(padding: 45)
        txtSearch.addCornerRadius(txtSearch.frame.size.height/2.0)
        
        viwTblContainer.addShadow(color: UIColor.darkGray, opacity: 0.5, offset: CGSize(width: 0, height: 0.2), radius: 4)
        
        viwKeywordContainer.addCornerRadius(4)
        viwKeywordContainer.isHidden = true
        
        lblSearchDesc.text = "Similar Keywords for"
        
        btnSave.addCornerRadius(20)
        btnSave.addShadow(color: UIColor.darkGray, opacity: 0.5, offset: CGSize(width: 0, height: 0.2), radius: 4)
        
        setLeftBackItem()
    }
    
    private func fetchSimilarKeywords(keyword: String) {
        guard AppDelegate.shared.creditBalance >= ApiCredit.similarKeywords else {
            Utility.showMessageAlert(title: Application.titleNoCreditMessage, andMessage: Application.descNoCreditMessage, withOkButtonTitle: "OK")
            return
        }
        IndicatorManager.showLoader()
        viewModel.fetchSimilarKeywords(keyword: keyword) { (success) in
            IndicatorManager.hideLoader()
            if success {
                self.viewModel.setCreditsScore(newCreditValue: -(ApiCredit.similarKeywords)) { (credits, success) in
                    guard success else {
                        return
                    }
                    self.creditBalanceView.lblBalance.text = String(credits)
                }
                self.lblKeyword.text = keyword
                self.lblSearchDesc.text = "Similar Keywords for \"\(keyword)\""
                self.viwKeywordContainer.isHidden = false
            } else {
                self.lblSearchDesc.text = "Similar Keywords for"
                self.viwKeywordContainer.isHidden = true
            }
            /*self.viewModel.fetchScoreForAllKeywords {
                IndicatorManager.hideLoader()
                DispatchQueue.main.async {
                    self.tblKeyword.reloadData()
                }
            }*/
            self.tblKeyword.reloadData()
        }
    }
    
    //MARK: - Actions
    @IBAction func onBtnSave(_ sender: Any) {
        guard !viewModel.arrSimilarKeywords.isEmpty else {
            return
        }
        var keywords = [String]()
        for info in viewModel.arrSimilarKeywords {
            if info.isSelected {
                info.isSelected = false
                keywords.append(info.key)
                //LocalPreferenceManager.shared.addKeywordData(keywordInfo: info)
            } else {
                //LocalPreferenceManager.shared.removeKeywordFromSavedKeywordData(keywordInfo: info)
            }
        }
        
        if !keywords.isEmpty {
            IndicatorManager.showLoader()
            viewModel.saveKeywords(keywords: keywords) { (success) in
                IndicatorManager.hideLoader()
                if success {
                    self.view.showToastAtBottom(message: "Keywords saved successfully!!")
                } else {
                    self.view.showToastAtBottom(message: "Keywords not saved successfully!!")
                }
                self.tblKeyword.reloadData()
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension SimilarKeywordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrSimilarKeywords.isEmpty ? 20 : viewModel.arrSimilarKeywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimilarKeywordTableViewCell.identifier, for: indexPath) as? SimilarKeywordTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row % 2 == 0 {
            cell.viwMainContainer.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        } else {
            cell.viwMainContainer.backgroundColor = UIColor.white
        }
        
        if viewModel.arrSimilarKeywords.isEmpty {
            cell.configureEmpty()
        } else {
            cell.configure(info: viewModel.arrSimilarKeywords[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !viewModel.arrSimilarKeywords.isEmpty {
            let index = indexPath.row
            viewModel.arrSimilarKeywords[index].isSelected = !viewModel.arrSimilarKeywords[index].isSelected
            tblKeyword.reloadData()
        }
    }
}

//MARK: - UITextFieldDelegate
extension SimilarKeywordsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyowrd = txtSearch.text, !keyowrd.isEmpty, viewModel.currentKeyword != keyowrd {
            fetchSimilarKeywords(keyword: txtSearch.text!)
        }
        textField.resignFirstResponder()
        return true
    }
}
