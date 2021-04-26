
import UIKit
import SwiftyStoreKit

class BuyCreditsViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var viewContainerBasic: UIView!
    @IBOutlet weak var viewContainerPremium: UIView!
    @IBOutlet weak var viewContainerEnterprise: UIView!
    @IBOutlet var arrBtnBuy: [UIButton]!
    @IBOutlet weak var btnBuyBasic: UIButton!
    @IBOutlet weak var btnBuyPremium: UIButton!
    @IBOutlet weak var btnBuyEnterprise: UIButton!
    
    // MARK: - Properties
    private var viewModel = BaseViewModel()
    
    private var productIds = [Application.basicPlanProductId, Application.premiumPlanProductId, Application.enterprisePlanProductId]
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        //fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBalanceViewRightItem()
    }
    
    //MRK: - Functions
    private func setupUI() {
        title = "Buy Keyword Credits"
        setLeftBackItem()
        
        viewContainerBasic.addCornerRadius(5)
        viewContainerPremium.addCornerRadius(5)
        viewContainerEnterprise.addCornerRadius(5)
        
        viewContainerBasic.addShadow(color: UIColor.darkGray, opacity: 1.0, offset: CGSize(width: 0, height: 0.8), radius: 1)
        viewContainerPremium.addShadow(color: UIColor.darkGray, opacity: 1.0, offset: CGSize(width: 0, height: 0.8), radius: 1)
        viewContainerEnterprise.addShadow(color: UIColor.darkGray, opacity: 1.0, offset: CGSize(width: 0, height: 0.8), radius: 1)
        
        for btn in arrBtnBuy {
            btn.addCornerRadius(15)
            btn.addShadow(color: UIColor.darkGray, opacity: 0.5, offset: CGSize(width: 0, height: 0.2), radius: 4)
        }
    }
    
    private func fetchProducts() {
        IndicatorManager.showLoader()
        // Get products info
        SwiftyStoreKit.retrieveProductsInfo(Set(productIds)) { products in
            IndicatorManager.hideLoader()
            let prod = Array(products.retrievedProducts)
            //            print(prod.map { $0.productIdentifier })
            //            print(prod.map { $0.priceLocale })
            //            print(prod.map { $0.price })
            //            print(prod.map { $0.localizedPrice })
            //            print(prod.map { $0.localizedTitle })
            
            // update button text value
            for item in prod {
                let priceTitle = item.localizedPrice
                if item.productIdentifier == Application.basicPlanProductId {
                    self.btnBuyBasic.setTitle(priceTitle, for: .normal)
                }
                
                if item.productIdentifier == Application.premiumPlanProductId {
                    self.btnBuyPremium.setTitle(priceTitle, for: .normal)
                }
                
                if item.productIdentifier == Application.enterprisePlanProductId {
                    self.btnBuyEnterprise.setTitle(priceTitle, for: .normal)
                }
                
            }
            
        }
    }
    
    private func setKeywordCreditValue(addValue: Int, purchase: PurchaseDetails?) {
        viewModel.setCreditsScore(newCreditValue: addValue) { (credit, success) in
            guard success else {
                return
            }
            self.creditBalanceView.lblBalance.text = String(credit)
            if let purchase = purchase, purchase.needsFinishTransaction {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
            Utility.showMessageAlert(title: "Success", andMessage: "Credit balance updated successfully.", withOkButtonTitle: "OK")
        }
    }
    
    private func purchaseCredits(productId: String) {
        IndicatorManager.showLoader()
        InAppManager.purchaseProduct(from: self, productId: productId) { (success, purchase) in
            IndicatorManager.hideLoader()
            if success {
                if productId == Application.basicPlanProductId {
                    self.setKeywordCreditValue(addValue: 150, purchase: purchase)
                } else if productId == Application.premiumPlanProductId {
                    self.setKeywordCreditValue(addValue: 500, purchase: purchase)
                } else if productId == Application.enterprisePlanProductId {
                    self.setKeywordCreditValue(addValue: 1000, purchase: purchase)
                }
            }
        }
    }

    //MARK: - Actions
    @IBAction func onBtnBuyBasicCredits(_ sender: Any) {
        purchaseCredits(productId: Application.basicPlanProductId)
    }
    
    @IBAction func onBtnBuyPremiumCredits(_ sender: Any) {
        purchaseCredits(productId: Application.premiumPlanProductId)
    }
    
    @IBAction func onBtnBuyEnterpriseCredits(_ sender: Any) {
        purchaseCredits(productId: Application.enterprisePlanProductId)
    }
}
