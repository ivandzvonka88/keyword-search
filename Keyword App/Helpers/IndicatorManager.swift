
import Foundation
import MBProgressHUD

class IndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
//    private static var refreshIndicator: MBProgressHUD = {
//        return MBProgressHUD.refreshing(addedTo: Utility.windowMain()!)
//    }()
    
    class func showLoader() {
        if loadingCount == 0 {
            // Show loader
            DispatchQueue.main.async {
//                refreshIndicator.show(animated: true)
                MBProgressHUD.showAdded(to: Utility.windowMain()!, animated: true)
            }
        }
        loadingCount += 1
    }
    
    class func hideLoader() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            // Hide loader
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: Utility.windowMain()!, animated: true)
//                refreshIndicator.hide(animated: true)
            }
        }
    }
}
