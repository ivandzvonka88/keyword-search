
import Foundation

extension String {
    
    public func toInt() -> Int? {
        let formatter =  NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        if let num = formatter.number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }

    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    /// EZSE: Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }

    /// EZSE: Trims white space and new line characters
    public mutating func trim() {
        self = self.trimmed()
    }

    /// EZSE: Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public func getDateWithFormate(formate: String, timezone: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(abbreviation: timezone)
        return formatter.date(from: self)! as Date
    }
    
    public func isValidStringDateFormate() -> Bool {
        if self == "0000-00-00 00:00:00" {
            return false
        }
        
        return true
    }
    
    public func isImageType() -> Bool {
        // image formats which you want to check
        let imageFormats = ["jpg", "png", "gif", "jpeg"]
        
        if URL(string: self) != nil  {
            
            let extensi = (self as NSString).pathExtension
            
            return imageFormats.contains(extensi)
        }
        return false
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func removeExtraaValue(value: String) -> String {
        return String(value.filter { !" ( ) - ".contains($0) })
    }
    
    func toJsonArray() -> [[String: Any]]? {
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
               print(jsonArray) // use the json here
                return jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}

extension Data {
    /// Data to Hexadecimal String
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}
