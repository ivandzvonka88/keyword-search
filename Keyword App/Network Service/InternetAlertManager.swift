
import UIKit

class InternetAlertManager: NSObject {
    
    private static var showCount = 0
    
    private static var alertController: UIAlertController?
    
    class func showMessageAlert(title: String, andMessage message: String, withOkButtonTitle okButtonTitle: String) {
        
        if showCount > 0 {
            return
        }
        
        showCount += 1
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            self.showCount -= 1
        }))
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
