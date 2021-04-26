
import UIKit
import Firebase
import IQKeyboardManagerSwift
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var creditBalance = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        setupApplicationAppearance()
        setupInAppPurchase()
        return true
    }
    
    // MARK: - Methods
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private func setupApplicationAppearance() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        let appearance = UINavigationBar.appearance()
        
        //appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        appearance.barTintColor = .white
        appearance.isTranslucent = false
        appearance.tintColor = UIColor.black
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = UIImage()
    }

    private func setupInAppPurchase() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                print(purchase.productId)
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    break
                // Unlock content
                case .failed, .purchasing, .deferred:
                break // Do nothing
                @unknown default:
                    break
                }
            }
        }
    }
}
