
import Foundation

extension Date {
    public func getDateStringWithFormate(_ formate: String, timezone: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(abbreviation: timezone)
        return formatter.string(from: self)
    }
    
    static func from(year: Int, month: Int, day: Int) -> Date? {
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: day))
        //return date
        /*let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil*/
    }
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
