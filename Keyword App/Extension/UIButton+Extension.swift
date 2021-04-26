
import UIKit

extension UIButton {

    public func setUnderlineButton() {
        let text = self.titleLabel?.text
        let titleString = NSMutableAttributedString(string: text!)
        titleString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSMakeRange(0, (text?.count)!))
        self.setAttributedTitle(titleString, for: .normal)
    }
    
    public func centerVertically(withPadding padding: CGFloat) {
        let imageSize: CGSize? = imageView?.frame.size
        let titleSize: CGSize? = titleLabel?.frame.size
        
        let totalHeight = (imageSize?.height ?? 0.0) + (titleSize?.height ?? 0.0) + CGFloat(padding)
        
        imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - (imageSize?.height ?? 0.0)), left: 0.0, bottom: 0.0, right: -(titleSize?.width ?? 0.0))
        
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -(imageSize?.width ?? 0.0), bottom: -(totalHeight - (titleSize?.height ?? 0.0)), right: 0.0)
    }
    
    func roundedButton() {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft],
                                     cornerRadii: CGSize(width: 90, height: 90))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    open override var isEnabled: Bool{
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    func setAnimationForSelect() {
        /*UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0, options: .allowUserInteraction, animations: { [weak self] in
            self?.transform = .identity
            }, completion: { (Success) in
         
        })*/
        
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0, options: .allowUserInteraction, animations: { [weak self] in
            self?.transform = .identity
            }, completion: nil)
    }
    
}


extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
