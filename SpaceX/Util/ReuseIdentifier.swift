import Foundation

protocol ReuseIdentifier { }

extension ReuseIdentifier {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
