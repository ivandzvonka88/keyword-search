
import Foundation
import UIKit
import CoreLocation
import LocalAuthentication

class Utility {
    
    // MARK: - Variables
    static let shared = Utility()
    
    var enableLog = true
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var timeStampInterval: TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    var timeStampString: String {
        return "\(Date().timeIntervalSince1970)"
    }
    
    // MARK: - Functions
    class func isLogEnable() -> Bool {
        return self.shared.enableLog
    }
    
    class func enableLog() {
        self.shared.enableLog = true
    }
    
    class func disableLog() {
        self.shared.enableLog = false
    }
    
    class func appDelegate() -> AppDelegate {
        return self.shared.appDelegate
    }
    
    class func windowMain() -> UIWindow? {
        return self.appDelegate().window
    }
    
    class func rootViewControllerMain() -> UIViewController? {
        return self.windowMain()?.rootViewController
    }
    
    class func applicationMain() -> UIApplication {
        return UIApplication.shared
    }
    
    class func getMajorSystemVersion() -> Int {
        let systemVersionStr = UIDevice.current.systemVersion   //Returns 7.1.1
        let mainSystemVersion = Int((systemVersionStr.split(separator: "."))[0])
        
        return mainSystemVersion!
    }
    
    class func getAppUniqueId() -> String {
        let uniqueId: UUID = UIDevice.current.identifierForVendor! as UUID
        
        return uniqueId.uuidString
    }
    
    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    class func showMessageAlert(title: String, andMessage message: String, withOkButtonTitle okButtonTitle: String) {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            
        }))
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showMessageAlert(in: UIViewController, title: String, andMessage message: String, withOkButtonTitle okButtonTitle: String) {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            
        }))
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - QueueType
public enum QueueType {
    case Main
    case Background
    case LowPriority
    case HighPriority
    
    var queue: DispatchQueue {
        switch self {
        case .Main:
            return DispatchQueue.main
        case .Background:
            return DispatchQueue(label: "com.app.queue",
                                 qos: .background,
                                 target: nil)
        case .LowPriority:
            return DispatchQueue.global(qos: .userInitiated)
        case .HighPriority:
            return DispatchQueue.global(qos: .userInitiated)
        }
    }
}

func performOn(_ queueType: QueueType, closure: @escaping () -> Void) {
    queueType.queue.async(execute: closure)
}
