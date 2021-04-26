
import UIKit

extension UITableViewCell {
    /// Return Nib
    public static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    /// Return Identifier
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    /// Return Nib
    public static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    /// Return Identifier
    public static var identifier: String {
        return String(describing: self)
    }
}
