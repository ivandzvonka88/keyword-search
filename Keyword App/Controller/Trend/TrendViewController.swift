
import UIKit
import Charts
import AlignedCollectionViewFlowLayout
import MessageUI
import IQKeyboardManagerSwift

class TrendViewController: BaseViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var txtSearch: UITextField!
    @IBOutlet private weak var clvKeywordCompare: UICollectionView!
    @IBOutlet private weak var lctClvKeywordCompareHeight: NSLayoutConstraint!
    @IBOutlet private weak var clvKeywords: UICollectionView!
    @IBOutlet private weak var lctClvKeywordsHeight: NSLayoutConstraint!
    @IBOutlet private weak var clvLegend: UICollectionView!
    @IBOutlet private weak var lctClvLegendHeight: NSLayoutConstraint!
    @IBOutlet private weak var viewContainerMonthly: UIView!
    @IBOutlet private weak var lblTime: UILabel!
    @IBOutlet private weak var btnMonthly: UIButton!
    @IBOutlet private weak var viewContainerAnywhere: UIView!
    @IBOutlet private weak var lblCountry: UILabel!
    @IBOutlet private weak var btnAnywhere: UIButton!
    @IBOutlet private weak var btnLanguage: UIButton!
    @IBOutlet private weak var viewContainerChart: UIView!
    @IBOutlet private weak var chartView: LineChartView!
    @IBOutlet private weak var imgFirst: UIImageView!
    @IBOutlet private weak var imgSecond: UIImageView!
    @IBOutlet private weak var viwLearnMoreContainer: UIView!
    
    @IBOutlet private weak var viwContainerTrendList: UIView!
    @IBOutlet private weak var lblTrendMonthYear: UILabel!
    @IBOutlet private weak var tblTrend: UITableView!
    @IBOutlet private weak var lctTblTrendHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var offscreenCellDict = [String: Any]()
    private var arrTextColor = [UIColor(named: "orange")!, UIColor(named: "green")!, UIColor(named: "Blue")!]
    private var arrMonths = ["Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
    private var arrLeftValue = ["1K", "2K", "3K", "4K", "5K"]
    private let maxKeywords = 3
    
    var viewModel = TrendViewModel()
    var fromSavedKeywordScreen = false
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        if fromSavedKeywordScreen {
            txtSearch.text = viewModel.arrKeywords[0]
            viewModel.arrKeywords.removeAll()
            fetchKeywordInfo(keyword: txtSearch.text!)
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
        title = "Keyword Trend"
        
        txtSearch.delegate = self
        txtSearch.addLeftPadding(padding: 45)
        txtSearch.addCornerRadius(txtSearch.frame.size.height/2.0)
        
        viewContainerMonthly.addCornerRadius(viewContainerMonthly.frame.size.height/2.0)
        viewContainerAnywhere.addCornerRadius(viewContainerAnywhere.frame.size.height/2.0)
        btnLanguage.addCornerRadius(3)
        
        viewContainerChart.addCornerRadius(5)
        
        viewContainerChart.addShadow(color: UIColor.lightGray, opacity: 0.3, offset: CGSize(width: 0, height: 0.5), radius: 6)

        imgFirst.addCornerRadius(5)
        imgSecond.addCornerRadius(5)
        
        viwContainerTrendList.addCornerRadius(10)
        viwContainerTrendList.applyBorder(1, borderColor: Application.Color.BORDER)
        
        viwLearnMoreContainer.addCornerRadius(10)
        viwLearnMoreContainer.applyBorder(1, borderColor: Application.Color.BORDER)
        
        setLeftBackItem()
        setupCollectionView()
        setupTableView()
        setupChart()
        
        viwLearnMoreContainer.isHidden = true
        viwContainerTrendList.isHidden = true
    }
    
    private func setupCollectionView() {
        
        /*let collectionViewLayout = clvKeywordCompare.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - (24.0 * 2.0), height: 40.0)*/
        
        let flowLayout1 = AlignedCollectionViewFlowLayout()
        flowLayout1.horizontalAlignment = .left
        flowLayout1.verticalAlignment = .top
        clvKeywordCompare.setCollectionViewLayout(flowLayout1, animated: true)
        
        clvKeywordCompare.dataSource = self
        clvKeywordCompare.delegate = self
        
        clvKeywordCompare.register(UINib(nibName: "KeywordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KeywordCollectionViewCell")
        clvKeywordCompare.register(UINib(nibName: "AddCompareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddCompareCollectionViewCell")
        
        
        let flowLayout2 = AlignedCollectionViewFlowLayout()
        flowLayout2.horizontalAlignment = .left
        flowLayout2.verticalAlignment = .top
        clvKeywords.setCollectionViewLayout(flowLayout2, animated: true)
        
        clvKeywords.dataSource = self
        clvKeywords.delegate = self
        
        clvKeywords.register(UINib(nibName: "KeywordVsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KeywordVsCollectionViewCell")
        
        
        let flowLayout3 = AlignedCollectionViewFlowLayout()
        flowLayout3.horizontalAlignment = .left
        flowLayout3.verticalAlignment = .top
        clvLegend.setCollectionViewLayout(flowLayout3, animated: true)
        
        clvLegend.dataSource = self
        clvLegend.delegate = self
        
        clvLegend.register(UINib(nibName: "ChartLegendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChartLegendCollectionViewCell")
    }
    
    private func setupTableView() {
        tblTrend.dataSource = self
        tblTrend.delegate = self
        
        tblTrend.register(UINib(nibName: "TrendTableViewCell", bundle: nil), forCellReuseIdentifier: "TrendTableViewCell")
    }
    
    private func setupChart() {
        // chart setup
        chartView.delegate = self
        
        let xAxis = chartView.xAxis
        //xAxis.axisMinimum = 0
        xAxis.granularity = 3600
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = true
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .bold)
        xAxis.labelTextColor = .darkGray
        xAxis.valueFormatter = DateValueFormatter()//CustomXAxisValueFormatter(axisValue: arrMonths)
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelCount = 5
        leftAxis.granularity = 1000
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelTextColor = .lightGray
        leftAxis.valueFormatter = LargeValueFormatter()
        
        let marker = TrendMarkerView.viewFromXib()!
        marker.chartView = chartView
        chartView.marker = marker
        chartView.extraTopOffset = 45
        chartView.extraLeftOffset = 30
        chartView.extraRightOffset = 50
        
        chartView.setScaleEnabled(true)
        chartView.rightAxis.enabled = false
        chartView.pinchZoomEnabled = true
        chartView.doubleTapToZoomEnabled = false
        //chartView.maxVisibleCount = 0
        chartView.legend.enabled = false
        chartView.animate(xAxisDuration: 0.5)
        
        /*let firstEntry = [ChartDataEntry(x: 0, y: 3.8 - 1),
                          ChartDataEntry(x: 1, y: 4.5 - 1),
                          ChartDataEntry(x: 2, y: 2.8 - 1),
                          ChartDataEntry(x: 3, y: 3 - 1),
                          ChartDataEntry(x: 4, y: 1.2 - 1)
        ]
        
        let secondEntry = [ChartDataEntry(x: 0, y: 1.8 - 1),
                           ChartDataEntry(x: 1, y: 2.2 - 1),
                           ChartDataEntry(x: 2, y: 2.5 - 1),
                           ChartDataEntry(x: 3, y: 2.5 - 1),
                           ChartDataEntry(x: 4, y: 4.8 - 1)
        ]
        
        let firstSet = setLineDataSet(entry: firstEntry, color: UIColor.red)
        let secondSet = setLineDataSet(entry: secondEntry, color: UIColor.yellow)
        
        chartView.data = LineChartData(dataSets: [firstSet, secondSet])*/
    }
    
    private func setLineDataSet(entry: [ChartDataEntry], color: UIColor) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entry, label: nil)
        dataSet.axisDependency = .left
        dataSet.setColor(color)
        dataSet.lineWidth = 2
        dataSet.drawCirclesEnabled = true
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = 5
        dataSet.setCircleColor(color)
        dataSet.drawVerticalHighlightIndicatorEnabled = true
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.highlightLineDashLengths = [5, 2]
        dataSet.highlightColor = .darkGray
        dataSet.drawValuesEnabled = false
            
        return dataSet
    }
    
    private func reloadAndUpdateCollectionViewHeight() {
        clvKeywordCompare.reloadData()
        clvKeywordCompare.layoutIfNeeded()
        lctClvKeywordCompareHeight.constant = clvKeywordCompare.collectionViewLayout.collectionViewContentSize.height
        if lctClvKeywordCompareHeight.constant == 0 {
            lctClvKeywordCompareHeight.constant = 40
        }
        
        clvKeywords.reloadData()
        clvKeywords.layoutIfNeeded()
        lctClvKeywordsHeight.constant = clvKeywords.collectionViewLayout.collectionViewContentSize.height
        if lctClvKeywordsHeight.constant == 0 {
            lctClvKeywordsHeight.constant = 40
        }
        
        clvLegend.reloadData()
        clvLegend.layoutIfNeeded()
        lctClvLegendHeight.constant = clvLegend.collectionViewLayout.collectionViewContentSize.height
        if lctClvLegendHeight.constant == 0 {
            lctClvLegendHeight.constant = 40
        }
    }
    
    private func reloadAndUpdateTableViewHeight() {
        tblTrend.reloadData()
        tblTrend.layoutIfNeeded()
        lctTblTrendHeight.constant = tblTrend.contentSize.height
        if lctTblTrendHeight.constant == 0 {
            lctTblTrendHeight.constant = 40
            viwContainerTrendList.isHidden = true
        } else {
            viwContainerTrendList.isHidden = false
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    private func fetchKeywordInfo(keyword: String) {
        guard AppDelegate.shared.creditBalance >= ApiCredit.trend else {
            Utility.showMessageAlert(title: Application.titleNoCreditMessage, andMessage: Application.descNoCreditMessage, withOkButtonTitle: "OK")
            return
        }
        IndicatorManager.showLoader()
        viewModel.fetchVolumeSearchInfo(keyword: keyword) { (success) in
            IndicatorManager.hideLoader()
            if success {
                self.viewModel.setCreditsScore(newCreditValue: -(ApiCredit.trend)) { (credits, success) in
                    guard success else {
                        return
                    }
                    self.creditBalanceView.lblBalance.text = String(credits)
                }
            }
            self.txtSearch.text = ""
            self.viewModel.arrSelectedMonthIndex.removeAll()
            self.setChartData()
            self.reloadAndUpdateCollectionViewHeight()
            self.reloadAndUpdateTableViewHeight()
        }
    }
    
    private func fetchAllKeywordInfo() {
        guard AppDelegate.shared.creditBalance >= (ApiCredit.trend * viewModel.arrKeywords.count) else {
            Utility.showMessageAlert(title: Application.titleNoCreditMessage, andMessage: Application.descNoCreditMessage, withOkButtonTitle: "OK")
            return
        }
        IndicatorManager.showLoader()
        viewModel.arVolumeSearchInfo.removeAll()
        DispatchQueue.global(qos: .userInitiated).async {
            let waitGroup = DispatchGroup()
            
            for keyword in self.viewModel.arrKeywords {
                waitGroup.enter()
                self.viewModel.fetchVolumeSearchInfo(keyword: keyword, refresh: true) { (success) in
                    if success {
                        self.viewModel.setCreditsScore(newCreditValue: -(ApiCredit.trend)) { (credits, success) in
                            guard success else {
                                return
                            }
                            self.creditBalanceView.lblBalance.text = String(credits)
                        }
                    }
                    waitGroup.leave()
                }
                waitGroup.wait()
            }
            
            waitGroup.notify(queue: .main) {
                IndicatorManager.hideLoader()
                self.viewModel.arrSelectedMonthIndex.removeAll()
                self.setChartData()
                self.reloadAndUpdateCollectionViewHeight()
                self.reloadAndUpdateTableViewHeight()
            }
        }
    }
    
    private func setChartData() {
        guard !viewModel.arVolumeSearchInfo.isEmpty else {
            chartView.data = nil
            return
        }
        let arrColors = [UIColor.red, UIColor.yellow, UIColor.blue]
        var arrDataSet = [LineChartDataSet]()
        for (index, volumeSearchInfo) in viewModel.arVolumeSearchInfo.enumerated() {
            
            var arrDataEntry = [ChartDataEntry]()
            for (infoIndex, monthlyInfo) in volumeSearchInfo.ms.enumerated() {
                let calendar = Calendar.current
                var components = calendar.dateComponents([.day, .month, .year], from: Date())
                components.year = monthlyInfo.year
                components.month = monthlyInfo.month
                components.day = 15
                arrDataEntry.append(ChartDataEntry(x: calendar.date(from: components)!.timeIntervalSince1970, y: Double(monthlyInfo.count), data: infoIndex))
            }
            arrDataEntry.sort(by: { $0.x < $1.x })
            let dataSet = setLineDataSet(entry: arrDataEntry, color: arrTextColor[index])
            arrDataSet.append(dataSet)
        }
        chartView.data = LineChartData(dataSets: arrDataSet)
        if let chartMarker = chartView.marker as? TrendMarkerView {
            let calendar = Calendar.current
            var components1 = calendar.dateComponents([.day, .month, .year], from: Date())
            var components2 = calendar.dateComponents([.day, .month, .year], from: Date())
            
            for volumeSearchInfo in viewModel.arVolumeSearchInfo {
                volumeSearchInfo.ms.sort { (info1, info2) -> Bool in
                    components1.year = info1.year
                    components1.month = info1.month
                    components1.day = 15
                    
                    components2.year = info2.year
                    components2.month = info2.month
                    components2.day = 15
                    
                    return calendar.date(from: components1)!.timeIntervalSince1970 < calendar.date(from: components2)!.timeIntervalSince1970
                }
            }
            
            chartMarker.arVolumeSearchInfo = viewModel.arVolumeSearchInfo
        }
    }
    
    private func showCountryPicker() {
        viewModel.generateCountryListForPicker()
        RPicker.selectOption(title: "Select Country", hideCancel: false, dataArray: viewModel.countryList, selectedIndex: viewModel.selectedCountryIndex) { (selectedCountry, atIndex) in
            // TODO: Your implementation for selection
            if self.viewModel.selectedCountryIndex != atIndex {
                self.viewModel.selectedCountryIndex = atIndex
                if atIndex == 0 {
                    self.lblCountry.text = "Country"
                } else {
                    self.lblCountry.text = selectedCountry
                }
                self.fetchAllKeywordInfo()
            }
        }
    }
    
    //MARK: - Actions
    @IBAction private func onBtnTime(_ sender: UIButton) {
        
    }
    
    @IBAction private func onBtnContry(_ sender: UIButton) {
        if viewModel.arCountry.isEmpty {
            IndicatorManager.showLoader()
            viewModel.fetchKeywordLocations { (success) in
                IndicatorManager.hideLoader()
                if success {
                    self.showCountryPicker()
                } else {
                    if !LocalPreferenceManager.shared.arrKeywordLocationInfo.isEmpty {
                        self.viewModel.arCountry = LocalPreferenceManager.shared.arrKeywordLocationInfo
                        self.showCountryPicker()
                    } else {
                        Utility.showMessageAlert(title: "Error", andMessage: "Unable to fetch countries, please try again later.", withOkButtonTitle: "OK")
                    }
                }
            }
        } else {
            showCountryPicker()
        }
    }
    
    @IBAction private func onBtnContactUs(_ sender: UIButton) {
        let recipientEmail = "contact@keywordplus.com"
        let subject = "Contact: Keyword Plus"
        let body = ""
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        } else {
            Utility.showMessageAlert(title: "Error", andMessage: "Email not configured on your device.", withOkButtonTitle: "OK")
        }
    }
    
    @IBAction private func onBtnFAQ(_ sender: UIButton) {
        let faqVC = FAQViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(faqVC, animated: true)
    }
    
    @IBAction private func onbtnHowToResearchKeyword(_ sender: UIButton) {
        let researchVC = ResearchViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(researchVC, animated: true)
    }
    
    @IBAction func onBtnBuyCredits(_ sender: Any) {
        let buyVc = BuyCreditsViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(buyVc, animated: true)
    }
    
    @IBAction func onBtnAdd(_ sender: Any) {
        impact.prepare()
        impact.impactOccurred()
        if txtSearch.isFirstResponder {
            if let keyowrd = txtSearch.text, !keyowrd.isEmpty {
                fetchKeywordInfo(keyword: txtSearch.text!)
            }
            txtSearch.resignFirstResponder()
        } else {
            txtSearch.text = ""
            txtSearch.becomeFirstResponder()
        }
    }
    
    @IBAction func onBtnRemove(_ sender: UIButton) {
        let index = sender.tag
        viewModel.arrKeywords.remove(at: index)
        viewModel.arVolumeSearchInfo.remove(at: index)
        if !viewModel.arrSelectedMonthIndex.isEmpty {
            viewModel.arrSelectedMonthIndex.remove(at: index)
        }
        self.setChartData()
        self.reloadAndUpdateCollectionViewHeight()
        self.reloadAndUpdateTableViewHeight()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension TrendViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clvKeywordCompare {
            if viewModel.arrKeywords.count < maxKeywords {
                return viewModel.arrKeywords.count + 1
            }
            return viewModel.arrKeywords.count
        } else {
            return viewModel.arrKeywords.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clvKeywordCompare {
            if viewModel.arrKeywords.count < maxKeywords && indexPath.row == viewModel.arrKeywords.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCompareCollectionViewCell", for: indexPath) as! AddCompareCollectionViewCell
                cell.btnAdd.addTarget(self, action: #selector(onBtnAdd(_:)), for: .touchUpInside)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCollectionViewCell", for: indexPath) as! KeywordCollectionViewCell
                cell.btnRemove.tag = indexPath.row
                cell.btnRemove.addTarget(self, action: #selector(onBtnRemove(_:)), for: .touchUpInside)
                cell.configure(keyword: viewModel.arrKeywords[indexPath.row], color: arrTextColor[indexPath.row])
                return cell
            }
        } else if collectionView == clvKeywords {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordVsCollectionViewCell", for: indexPath) as! KeywordVsCollectionViewCell
            cell.configure(keyword: viewModel.arrKeywords[indexPath.row], color: arrTextColor[indexPath.row])
            if indexPath.row == viewModel.arrKeywords.count-1 {
                cell.viewContainerVs.isHidden = true
            } else {
                cell.viewContainerVs.isHidden = false
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartLegendCollectionViewCell", for: indexPath) as! ChartLegendCollectionViewCell
            cell.configure(keyword: viewModel.arrKeywords[indexPath.row], color: arrTextColor[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == clvKeywordCompare {
            if viewModel.arrKeywords.count < maxKeywords && indexPath.row == viewModel.arrKeywords.count {
                var cell = offscreenCellDict["AddCompareCollectionViewCell"] as? AddCompareCollectionViewCell

                if cell == nil {
                    cell = Bundle.main.loadNibNamed("AddCompareCollectionViewCell", owner: nil, options: nil)?.last as? AddCompareCollectionViewCell
                    offscreenCellDict["AddCompareCollectionViewCell"] = cell
                }

                cell?.updateConstraintsIfNeeded()
                //cell?.lblTitle.preferredMaxLayoutWidth = collectionView.frame.width - 15 - 15
                return cell!.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            } else {
                var cell = offscreenCellDict["KeywordCollectionViewCell"] as? KeywordCollectionViewCell

                if cell == nil {
                    cell = Bundle.main.loadNibNamed("KeywordCollectionViewCell", owner: nil, options: nil)?.last as? KeywordCollectionViewCell
                    offscreenCellDict["KeywordCollectionViewCell"] = cell
                }

                cell?.configure(keyword: viewModel.arrKeywords[indexPath.row], color: arrTextColor[indexPath.row])
                //cell?.lblKeyword.text = viewModel.emailAt(index: index)
                cell?.updateConstraintsIfNeeded()
                cell?.lblKeyword.preferredMaxLayoutWidth = collectionView.frame.width - 15 - 15
                return cell!.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            }
        } else if collectionView == clvKeywords {
            var cell = offscreenCellDict["KeywordVsCollectionViewCell"] as? KeywordVsCollectionViewCell

            if cell == nil {
                cell = Bundle.main.loadNibNamed("KeywordVsCollectionViewCell", owner: nil, options: nil)?.last as? KeywordVsCollectionViewCell
                offscreenCellDict["KeywordVsCollectionViewCell"] = cell
            }

            cell?.configure(keyword: viewModel.arrKeywords[indexPath.row], color: arrTextColor[indexPath.row])
            //cell?.lblKeyword.text = viewModel.emailAt(index: index)
            cell?.updateConstraintsIfNeeded()
            if indexPath.row == viewModel.arrKeywords.count-1 {
                cell?.viewContainerVs.isHidden = true
                cell?.lblKeyword.preferredMaxLayoutWidth = collectionView.frame.width - 5 - 5
            } else {
                cell?.viewContainerVs.isHidden = false
                cell?.lblKeyword.preferredMaxLayoutWidth = collectionView.frame.width - 26 - 5 - 5
            }
            
            return cell!.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        } else {
            var cell = offscreenCellDict["ChartLegendCollectionViewCell"] as? ChartLegendCollectionViewCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("ChartLegendCollectionViewCell", owner: nil, options: nil)?.last as? ChartLegendCollectionViewCell
                offscreenCellDict["ChartLegendCollectionViewCell"] = cell
            }
            
            cell?.configure(keyword: viewModel.arrKeywords[indexPath.row], color: arrTextColor[indexPath.row])
            //cell?.lblKeyword.text = viewModel.emailAt(index: index)
            cell?.updateConstraintsIfNeeded()
            
            return cell!.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == clvKeywordCompare {
            if viewModel.arrKeywords.count < maxKeywords && indexPath.row == viewModel.arrKeywords.count {
//                if txtSearch.isFirstResponder {
//                    if let keyowrd = txtSearch.text, !keyowrd.isEmpty {
//                        fetchKeywordInfo(keyword: txtSearch.text!)
//                    }
//                    txtSearch.resignFirstResponder()
//                } else {
//                    txtSearch.text = ""
//                    txtSearch.becomeFirstResponder()
//                }
            } else {
                let alertController = UIAlertController(title: "Remove confirmation", message: "Are you sure you want to remove selected keyword?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.viewModel.arVolumeSearchInfo.remove(at: indexPath.row)
                    self.viewModel.arrKeywords.remove(at: indexPath.row)
                    self.setChartData()
                    self.reloadAndUpdateCollectionViewHeight()
                }))
                alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrSelectedMonthIndex.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as? TrendTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(info: viewModel.arVolumeSearchInfo[indexPath.row], monthInfoIndex: viewModel.arrSelectedMonthIndex[indexPath.row], color: arrTextColor[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITextFieldDelegate
extension TrendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if viewModel.arrKeywords.count == maxKeywords {
            
        } else if let keyowrd = txtSearch.text, !keyowrd.isEmpty {
            fetchKeywordInfo(keyword: txtSearch.text!)
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - ChartViewDelegate
extension TrendViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        DLog("chartValueSelected")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        let date = Date(timeIntervalSince1970: entry.x)
        lblTrendMonthYear.text = dateFormatter.string(from: date)
        viewModel.refreshSelectedMonthArray(entry: entry)
        reloadAndUpdateTableViewHeight()
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        DLog("chartValueNothingSelected")
        viewModel.arrSelectedMonthIndex.removeAll()
        reloadAndUpdateTableViewHeight()
    }
}

// MARK: CustomAxisValueFormatter
class CustomXAxisValueFormatter: IAxisValueFormatter {
    
    private var arrMonths = ["Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var axisValue: [String]
    
    init(axisValue: [String]) {
        self.axisValue = axisValue
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSinceReferenceDate: value)
        return date.getDateStringWithFormate("MMM yyyy", timezone: TimeZone.current.abbreviation()!)
        //let index = Int(value)
        //return axisValue[index]
    }

}

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "MMM"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

// MARK: MFMailComposeViewControllerDelegate
extension TrendViewController: MFMailComposeViewControllerDelegate {
    
}
