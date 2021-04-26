
import UIKit

extension UILabel {

    public func setUnderLine() {
        guard let text = self.text else { return }
        let textRange = NSRange(location: 0, length: text.count) //NSMakeRange(0, text.count)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
        self.attributedText = attributedString
    }
    
    func strikeOnLabel(lineStyle: Int) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSAttributedString.Key.strikethroughStyle: lineStyle, NSAttributedString.Key.strikethroughColor: #colorLiteral(red: 0.1411764706, green: 0.07450980392, blue: 0.1960784314, alpha: 1), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1411764706, green: 0.07450980392, blue: 0.1960784314, alpha: 1), NSAttributedString.Key.font: UIFont(name: Application.Font.latoRegular, size: 16.0)!], range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
