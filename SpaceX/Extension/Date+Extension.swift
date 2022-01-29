import UIKit

extension String {
    func toISODate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        let str = dateFormatter.string(from: self)

        return str
    }
}
