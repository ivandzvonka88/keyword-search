
import UIKit
import SwiftyStoreKit
import StoreKit

class InAppManager {
    
    class func handleInAppPurchaseError(error: SKError) {
        var errorMessage = ""
        switch error.code {
        case .unknown:
            print("Unknown error. Please contact support")
            errorMessage = "Unknown error. Please contact support"
        case .clientInvalid:
            print("Not allowed to make the payment")
            errorMessage = "Not allowed to make the payment"
        case .paymentCancelled:
            errorMessage = ""
            break
        case .paymentInvalid:
            print("The purchase identifier was invalid")
            errorMessage = "Something went wrong please try again later"
        case .paymentNotAllowed:
            print("The device is not allowed to make the payment")
            errorMessage = "The device is not allowed to make the payment"
        case .storeProductNotAvailable:
            print("The product is not available in the current storefront")
            errorMessage = "The product is not available in the current storefront"
        case .cloudServicePermissionDenied:
            print("Access to cloud service information is not allowed")
            errorMessage = "Access to cloud service information is not allowed"
        case .cloudServiceNetworkConnectionFailed:
            print("Could not connect to the network")
            errorMessage = "Could not connect to the network"
        case .cloudServiceRevoked:
            print("User has revoked permission to use this cloud service")
            errorMessage = "User has revoked permission to use this cloud service"
        default:
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
        
        if !errorMessage.isEmpty {
            Utility.showMessageAlert(title: "Purchase Error", andMessage: errorMessage, withOkButtonTitle: "OK")
        }
    }
    
    class func purchaseProduct(from: UIViewController, productId: String, completionHandler: @escaping (Bool, PurchaseDetails?) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo(Set([productId])) { result in
            
            let products = result.retrievedProducts
            let arrProducts = Array(products)
            
            if arrProducts.count > 0 {
                let selectedProduct = arrProducts[0]
                
                SwiftyStoreKit.purchaseProduct(selectedProduct, atomically: false) { result in
                    switch result {
                    case .success(let purchase):
                        
                        print("Purchase Success: \(purchase.productId)")
                        
                        /*if purchase.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }*/
                        
                        validateNormalPurchaseReceipt(for: purchase.productId) { (success) in
                            completionHandler(success, purchase)
                        }
                        
                    case .error(let error):
                        self.handleInAppPurchaseError(error: error)
                        completionHandler(false, nil)
                    }
                }
            } else {
                completionHandler(false, nil)
                Utility.showMessageAlert(in: from, title: "Error", andMessage: "Unable to fetch product info, please try again later.", withOkButtonTitle: "OK")
            }
        }
    }
    
    class func validateNormalPurchaseReceipt(for productId: String, completionHandler: @escaping (Bool) -> Void) {
        let appleValidator = AppleReceiptValidator(service: (Application.enableSandboxInApp ? .sandbox : .production), sharedSecret: Application.appShrSec)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { results in
            if case .success(let receipt) = results {
                DLog("verifyReceipt receipt = ", receipt)
                let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productId, inReceipt: receipt)
                DLog("verifyReceipt purchaseResult = ", purchaseResult)
                switch purchaseResult {
                case .purchased(let receiptItem):
                    DLog("\(productId) is purchased: \(receiptItem)")
                    completionHandler(true)
                case .notPurchased:
                    DLog("The user has never purchased \(productId)")
                    completionHandler(false)
                }
                
            } else {
                print("receipt verification error")
            }
        }
    }
    
    class func validateAutoRenewableReceipt(for productId: String, completionHandler: @escaping (Bool) -> Void) {
        let appleValidator = AppleReceiptValidator(service: (Application.enableSandboxInApp ? .sandbox : .production), sharedSecret: Application.appShrSec)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { results in
            if case .success(let receipt) = results {
                DLog("verifyReceipt receipt = ", receipt)
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productId, inReceipt: receipt)
                DLog("verifySubscription purchaseResult = ", purchaseResult)
                switch purchaseResult {
                case .purchased(let expiryDate, _):
                    DLog("Product is valid until \(expiryDate)")
                    completionHandler(true)
                case .expired(let expiryDate, _):
                    DLog("Product is expired since \(expiryDate)")
                    completionHandler(false)
                case .notPurchased:
                    DLog("This product has never been purchased")
                    completionHandler(false)
                }
                
            } else {
                print("receipt verification error")
                completionHandler(false)
            }
        }
    }
}

extension SKProduct {
    fileprivate static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }

    var localizedPrice: String {
        if self.price == 0.00 {
            return "Get"
        } else {
            let formatter = SKProduct.formatter
            formatter.locale = self.priceLocale

            guard let formattedPrice = formatter.string(from: self.price)else {
                return "Unknown Price"
            }

            return formattedPrice
        }
    }
}
