
import UIKit
//import SkyFloatingLabelTextField

extension UITextField {

    public func addLeftPadding(padding: CGFloat) {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)

        self.leftView = tempView
        self.leftViewMode = .always
    }
    
    public func addRightPadding(padding: CGFloat) {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        
        self.rightView = tempView
        self.rightViewMode = .always
    }

    @IBInspectable public var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }

    public func addImageToRightSide(image: UIImage, width: CGFloat) {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        imageView.contentMode = .center
        imageView.image = image

        self.rightView = imageView
        self.rightViewMode = .always
    }
    
    public func addImageToLeftSide(image: UIImage, width: CGFloat) {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        imageView.contentMode = .center
        imageView.image = image
        
        self.leftView = imageView
        self.leftViewMode = .always
    }
    
    func setBottomLine() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }

}
