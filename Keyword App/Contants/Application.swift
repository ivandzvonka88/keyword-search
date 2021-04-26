
import Foundation
import UIKit

/// Application
struct Application {
    
    /// Constants
    static let keysearchKey = "55c572THQRMmV53b08f792FsBQmReV"
    static let dataforseoApiLogin = "hashim.ik217@gmail.com"
    static let dataforseoApiPass = "weWrCJhvDzpRwnt5"
    
    static let titleNoCreditMessage = "No credit!!"
    static let descNoCreditMessage = "You have not sufficient credits available. Please buy some credits to continue."
    
    /// In App details
    static let appShrSec = "c878f9ef6f8a4b4595a7b24d8e6bc3af"
    static let basicPlanProductId       =   "keywordplus.basic"
    static let premiumPlanProductId     =   "keywordplus.premium"
    static let enterprisePlanProductId  =   "keywordplus.enterprise"
    
    /// Debug Log enable or not
    static let isDevelopmentMode = true
    static let debug: Bool = true
    static let enableSandboxInApp = true
    
    /// Application Mode
    static let mode = Mode.sendbox
    
    // Fire Store table Names
    struct Tables {
        static let users = "users"
        static let savedKeywords = "savedKeywords"
        static let keywordField = "keyword"      // savedKeywords collection field name
    }
    
    /// Application in production or sendbox
    enum Mode {
        case sendbox
        case production
    }
    
    /// App Color
    struct Color {
        static let APP_THEME_COLOR  = UIColor(named: "Theme")
        static let BORDER = #colorLiteral(red: 0.9411764706, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        static let FONT_COLOR       = #colorLiteral(red: 0.6, green: 0.5607843137, blue: 0.6352941176, alpha: 1)
        static let FONT_BLACK_COLOR = #colorLiteral(red: 0.1411764706, green: 0.07450980392, blue: 0.1960784314, alpha: 1)
    }
    
    /// App Fonts
    struct Font {
        static let poppinsRegular = "Poppins-Regular"
        static let latoRegular = "Lato-Regular"
        static let latoMedium = "Lato-Medium"
        static let latoBold = "Lato-Bold"
        static let latoHeavy = "Lato-Heavy"
    }
    
    struct API {
        static let BASE_URL = ""
    }
    
    struct Device {
        static let version = UIDevice.current.systemVersion
    }
}

extension Notification.Name {
    static let updateCreditBalance = Notification.Name("UPDATE_CREDIT_BALANCE")
}
