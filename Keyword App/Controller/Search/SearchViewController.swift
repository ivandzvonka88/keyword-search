
import UIKit
import Charts
import MKMagneticProgress
import IQKeyboardManagerSwift

class SearchViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var txtSearch: UITextField!
    @IBOutlet private weak var viwKeywordContainer: UIView!
    @IBOutlet weak var lblKeyword: UILabel!
    @IBOutlet weak var viewContainerKeywordDifficulty: UIView!
    @IBOutlet weak var circularProgressView: MKMagneticProgress!
    @IBOutlet weak var lblAvgCpc: UILabel!
    @IBOutlet weak var viewContainerChart: UIView!
    @IBOutlet weak var lblKeywordVolume: UILabel!
    @IBOutlet private weak var chartView: LineChartView!
    @IBOutlet weak var viewContainerSearchAnalysisTitle: UIView!
    @IBOutlet weak var lblTotalUrl: UILabel!
    @IBOutlet private weak var tblURL: UITableView!
    @IBOutlet private weak var lctTblHeight: NSLayoutConstraint!

    // MARK: Properties
    var viewModel = SearchKeywordViewModel()
    var fromSavedKeywordScreen = false
    private var arrChartColor = [UIColor(named: "orange")!, UIColor(named: "green")!, UIColor(named: "Blue")!]
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        reloadAndUpdateData()
        if fromSavedKeywordScreen {
            txtSearch.text = viewModel.currentKeyword
            fetchKeywordDifficultyInfo(keyword: viewModel.currentKeyword)
            fetchKeywordInfo(keyword: viewModel.currentKeyword)
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
        title = "Search Volume"
        
        lblKeywordVolume.text = ""
        lblAvgCpc.text = "-"
        circularProgressView.setProgress(progress: 0, animated: false)
        
        tblURL.delegate = self
        tblURL.dataSource = self
        
        txtSearch.delegate = self
        txtSearch.addLeftPadding(padding: 45)
        txtSearch.addCornerRadius(txtSearch.frame.size.height/2.0)
        viwKeywordContainer.addCornerRadius(5)
        
        viewContainerChart.addCornerRadius(5)
        viewContainerKeywordDifficulty.addCornerRadius(5)
        
        viewContainerChart.addShadow(color: UIColor.lightGray, opacity: 0.3, offset: CGSize(width: 0, height: 0.5), radius: 6)
        viewContainerKeywordDifficulty.addShadow(color: UIColor.lightGray, opacity: 0.3, offset: CGSize(width: 0, height: 0.5), radius: 6)
        
        setLeftBackItem()
        
        viewContainerSearchAnalysisTitle.addShadow(color: UIColor.darkGray, opacity: 0.5, offset: CGSize(width: 0, height: 0.2), radius: 4)
        
        circularProgressView.percentLabelFormat = "%.0f/100"
        
        setupChart()
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
    
    private func fetchKeywordDifficultyInfo(keyword: String) {
        guard AppDelegate.shared.creditBalance >= ApiCredit.volumeSearch else {
            //Utility.showMessageAlert(title: Application.titleNoCreditMessage, andMessage: Application.descNoCreditMessage, withOkButtonTitle: "OK")
            return
        }
        IndicatorManager.showLoader()
        viewModel.fetchKeywordDifficultyAndAnalysisData(keyword: keyword) { (success) in
            IndicatorManager.hideLoader()
            self.reloadAndUpdateData()
        }
    }
    
    private func fetchKeywordInfo(keyword: String) {
        guard AppDelegate.shared.creditBalance >= ApiCredit.volumeSearch else {
            Utility.showMessageAlert(title: Application.titleNoCreditMessage, andMessage: Application.descNoCreditMessage, withOkButtonTitle: "OK")
            return
        }
        IndicatorManager.showLoader()
        viewModel.fetchVolumeSearchInfo(keyword: keyword) { (success) in
            IndicatorManager.hideLoader()
            if success {
                self.viewModel.setCreditsScore(newCreditValue: -(ApiCredit.volumeSearch)) { (credits, success) in
                    guard success else {
                        return
                    }
                    self.creditBalanceView.lblBalance.text = String(credits)
                }
            }
            self.setChartData()
        }
    }
    
    private func reloadAndUpdateData() {
        guard viewModel.keywordDifficultyInfo != nil else {
            viwKeywordContainer.isHidden = true
            lblTotalUrl.text = ""
            //circularProgressView.setProgress(progress: 0, animated: false)
            return
        }
        
        viwKeywordContainer.isHidden = false
        lblKeyword.text = viewModel.currentKeyword
        lblTotalUrl.text = "\(viewModel.keywordDifficultyInfo.analysisResults.count) URL"
        //lblKeywordVolume.text = "\(viewModel.keywordDifficultyInfo.volume)"
        //lblAvgCpc.text = "$\(viewModel.keywordDifficultyInfo.cpc)"
        //circularProgressView.progressShapeColor = viewModel.keywordDifficultyInfo.score.getScoreColor()
        //circularProgressView.setProgress(progress: CGFloat(viewModel.keywordDifficultyInfo.score.toInt() ?? 0)/100.0, animated: false)
        
        tblURL.reloadData()
        tblURL.layoutIfNeeded()
        lctTblHeight.constant = tblURL.contentSize.height
        if lctTblHeight.constant == 0 {
            lctTblHeight.constant = 40
        }
    }
    
    private func setChartData() {
        guard viewModel.volumeSearchInfo != nil else {
            chartView.data = nil
            return
        }
        lblAvgCpc.text = String(format: "$%.2f", viewModel.volumeSearchInfo.cpc)
        lblKeywordVolume.text = "\(viewModel.volumeSearchInfo.sv)"
        viwKeywordContainer.isHidden = false
        lblKeyword.text = viewModel.currentKeyword
        circularProgressView.progressShapeColor = (viewModel.volumeSearchInfo.cmp * 100).getScoreColor()
        circularProgressView.setProgress(progress: CGFloat((viewModel.volumeSearchInfo.cmp * 100).rounded(.toNearestOrAwayFromZero))/100.0, animated: false)
        
        var arrDataSet = [LineChartDataSet]()
        
        var arrDataEntry = [ChartDataEntry]()
        for (infoIndex, monthlyInfo) in viewModel.volumeSearchInfo.ms.enumerated() {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.day, .month, .year], from: Date())
            components.year = monthlyInfo.year
            components.month = monthlyInfo.month
            components.day = 15
            arrDataEntry.append(ChartDataEntry(x: calendar.date(from: components)!.timeIntervalSince1970, y: Double(monthlyInfo.count), data: infoIndex))
        }
        arrDataEntry.sort(by: { $0.x < $1.x })
        let dataSet = setLineDataSet(entry: arrDataEntry, color: arrChartColor[2])
        arrDataSet.append(dataSet)
        
        chartView.data = LineChartData(dataSets: arrDataSet)
        if let chartMarker = chartView.marker as? TrendMarkerView {
            let calendar = Calendar.current
            var components1 = calendar.dateComponents([.day, .month, .year], from: Date())
            var components2 = calendar.dateComponents([.day, .month, .year], from: Date())
            
            viewModel.volumeSearchInfo.ms.sort { (info1, info2) -> Bool in
                components1.year = info1.year
                components1.month = info1.month
                components1.day = 15
                
                components2.year = info2.year
                components2.month = info2.month
                components2.day = 15
                
                return calendar.date(from: components1)!.timeIntervalSince1970 < calendar.date(from: components2)!.timeIntervalSince1970
            }
            
            chartMarker.arVolumeSearchInfo = [viewModel.volumeSearchInfo]
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.keywordDifficultyInfo == nil ? 5 : viewModel.keywordDifficultyInfo.analysisResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KeywordAnalysisTableViewCell.identifier, for: indexPath) as? KeywordAnalysisTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row % 2 == 0 {
            cell.viwMainContainer.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        } else {
            cell.viwMainContainer.backgroundColor = UIColor.white
        }
        
        if viewModel.keywordDifficultyInfo == nil {
            cell.configureEmpty()
        } else {
            cell.configure(info: viewModel.keywordDifficultyInfo.analysisResults[indexPath.row])
        }
        
        return cell
    }
    
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyowrd = txtSearch.text, !keyowrd.isEmpty, viewModel.currentKeyword != keyowrd {
            fetchKeywordDifficultyInfo(keyword: keyowrd)
            fetchKeywordInfo(keyword: keyowrd)
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - ChartViewDelegate
extension SearchViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        DLog("chartValueSelected")
        lblKeywordVolume.text = "\(viewModel.getVolumeForChartEntry(entry: entry))"
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        DLog("chartValueNothingSelected")
        lblKeywordVolume.text = "\(viewModel.volumeSearchInfo.sv)"
    }
}
