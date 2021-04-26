
import UIKit

class SavedKeywordViewController: BaseViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var tblSave: UITableView!
    @IBOutlet weak var btnRemove: UIButton!
    
    // MARK: - Properties
    var viewModel = SavedKeywordViewModel()
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        IndicatorManager.showLoader()
        viewModel.fetchSavedKeywords {
            IndicatorManager.hideLoader()
            self.tblSave.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBalanceViewRightItem()
    }

    // MARK: Methods
    private func setupUI() {
        title = ""
        
        tblSave.delegate = self
        tblSave.dataSource = self
        
        btnRemove.addCornerRadius(20)
        btnRemove.addShadow(color: UIColor.darkGray, opacity: 0.5, offset: CGSize(width: 0, height: 0.2), radius: 4)
        
        setLeftBackItem()
    }
    
    //MARK: - Actions
    @IBAction func onBtnPieChart(_ sender: UIButton) {
        let index = sender.tag
        let nextVc = SearchViewController.instantiate(fromAppStoryboard: .Main)
        nextVc.fromSavedKeywordScreen = true
        nextVc.viewModel.currentKeyword = viewModel.arrSavedKeywords[index].keyword
        navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func onBtnLineChart(_ sender: UIButton) {
        let index = sender.tag
        let nextVc = TrendViewController.instantiate(fromAppStoryboard: .Main)
        nextVc.fromSavedKeywordScreen = true
        nextVc.viewModel.arrKeywords.append(viewModel.arrSavedKeywords[index].keyword)
        navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func onBtnLink(_ sender: UIButton) {
           let index = sender.tag
           let nextVc = SimilarKeywordsViewController.instantiate(fromAppStoryboard: .Main)
           nextVc.fromSavedKeywordScreen = true
           nextVc.viewModel.currentKeyword = viewModel.arrSavedKeywords[index].keyword
           navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func onBtnRemove(_ sender: Any) {
        guard !viewModel.arrSavedKeywords.isEmpty else {
            return
        }
        var keywords = [String]()
        for info in viewModel.arrSavedKeywords {
            if info.isSelected {
                keywords.append(info.keyword)
                //LocalPreferenceManager.shared.removeKeywordFromSavedKeywordData(keywordInfo: info)
            }
        }
        
        if !keywords.isEmpty {
            IndicatorManager.showLoader()
            viewModel.removeKeywords(keywords: keywords) { (success) in
                if success {
                    self.view.showToastAtBottom(message: "Keywords removed successfully!!")
                    self.viewModel.fetchSavedKeywords {
                        IndicatorManager.hideLoader()
                        self.tblSave.reloadData()
                    }
                } else {
                    IndicatorManager.hideLoader()
                    self.view.showToastAtBottom(message: "Keywords not removed successfully!!")
                }
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension SavedKeywordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrSavedKeywords.isEmpty ? 20 : viewModel.arrSavedKeywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedKeywordTableViewCell.identifier, for: indexPath) as? SavedKeywordTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row % 2 == 0 {
            cell.viwMainContainer.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        } else {
            cell.viwMainContainer.backgroundColor = UIColor.white
        }
        
        cell.btnPieChart.tag = indexPath.row
        cell.btnLineChart.tag = indexPath.row
        cell.btnLink.tag = indexPath.row
        
        cell.btnPieChart.addTarget(self, action: #selector(onBtnPieChart(_:)), for: .touchUpInside)
        cell.btnLineChart.addTarget(self, action: #selector(onBtnLineChart(_:)), for: .touchUpInside)
        cell.btnLink.addTarget(self, action: #selector(onBtnLink(_:)), for: .touchUpInside)
        
        if viewModel.arrSavedKeywords.isEmpty {
            cell.confugureEmpty()
        } else {
            cell.configure(info: viewModel.arrSavedKeywords[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !viewModel.arrSavedKeywords.isEmpty else {
            return
        }
        let index = indexPath.row
        viewModel.arrSavedKeywords[index].isSelected = !viewModel.arrSavedKeywords[index].isSelected
        tblSave.reloadData()
    }
}
