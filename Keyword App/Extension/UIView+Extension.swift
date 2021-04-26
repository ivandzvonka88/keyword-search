
import Foundation
import UIKit
import Toast_Swift

extension UIView {

    public func showToastAtBottom(message: String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .black
        self.makeToast(message, duration: 3.0, position: .bottom, style: style)
    }

    public func showToastAtTop(message: String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .black
        self.makeToast(message, duration: 3.0, position: .top, style: style)
    }

    public func showToastAtCenter(message: String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .black
        self.makeToast(message, duration: 3.0, position: .center, style: style)
    }

    public func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

    public func applyBorder(_ width: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
    }

    public func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }

    public func applyViewGradient(colors : [UIColor]) {
        let image = UIImage.gradientImageWith(size: CGSize(width: self.bounds.width, height: self.bounds.height), colors: colors)
        self.backgroundColor = UIColor.init(patternImage: image!)
    }
    
    public func addShadowToSpecificCorner(top: Bool, left: Bool, bottom: Bool, right: Bool, shadowRadius: CGFloat = 2.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if !top {
            y+=(shadowRadius+1)
        }
        if !bottom {
            viewHeight-=(shadowRadius+1)
        }
        if !left {
            x+=(shadowRadius+1)
        }
        if !right {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))

        path.addLine(to: CGPoint(x: x, y: viewHeight))

        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))

        path.addLine(to: CGPoint(x: viewWidth, y: y))

        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    public func addShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3
    }
    
    func addSubViewWithAutolayout(subView: UIView) {
        self.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = true
        
        subView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        subView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        /*if #available(iOS 11.0, *) {
            let guide = self.safeAreaLayoutGuide
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            subView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            subView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        } else {
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }*/
        
        subView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    public func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
}
