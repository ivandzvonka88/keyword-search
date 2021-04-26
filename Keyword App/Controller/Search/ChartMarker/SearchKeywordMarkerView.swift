
import UIKit
import Charts

class SearchKeywordMarkerView: MarkerView {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblKeywordVolume: UILabel!
    
    var arVolumeSearchInfo = [VolumeSearchInfo]()
    
    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    public var suffix = ["", "k", "m", "b", "t"]
    
    /// An appendix text to be added at the end of the formatted value.
    public var appendix: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.offset.x = -self.frame.size.width / 2.0
        self.offset.y = -self.frame.size.height + 10
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        let date = Date(timeIntervalSince1970: entry.x)
        lblDate.text = dateFormatter.string(from: date)
        lblKeywordVolume.text = ""
        /*let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        //let day = calendar.component(.day, from: date)
        
        if let index = entry.data as? Int {
            var displayString = ""
            for searchInfo in arVolumeSearchInfo {
                for monthInfo in searchInfo.ms where monthInfo.year == year && monthInfo.month == month {
                    displayString = displayString + "\(searchInfo.key) : \(format(value: Double(monthInfo.count)))\n"
                }
            }
            if !displayString.isEmpty {
                displayString.removeLast()
            }
            lblKeywordVolume.text = displayString
        } else {
            lblKeywordVolume.text = format(value: Double(entry.y))
        }*/
        
        layoutIfNeeded()
    }
    
    fileprivate func format(value: Double) -> String {
        var sig = value
        var length = 0
        let maxLength = suffix.count - 1
        
        while sig >= 1000.0 && length < maxLength {
            sig /= 1000.0
            length += 1
        }
        
        var r = String(format: "%2.f", sig) + suffix[length]
        
        if let appendix = appendix {
            r += appendix
        }
        
        return r
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
