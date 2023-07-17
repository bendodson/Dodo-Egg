// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

public struct DebugCategory: RawRepresentable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static let app = DebugCategory(rawValue: "app")
    public static let ui = DebugCategory(rawValue: "ui")
}

public enum DebugLogLevel: String {
    case debug
    case info
    case event
    case warn
    case error
}

public struct DebugMessage {
    public let date: Date
    public let category: String
    public let level: DebugLogLevel
    public let message: String
    public let userInfo: [String: Any]
    public let codepath: String
    
    public init(category: String, level: DebugLogLevel, message: String, userInfo: [String : Any], codepath: String) {
        self.category = category
        self.level = level
        self.message = message
        self.userInfo = userInfo
        self.codepath = codepath
        self.date = Date()
    }
}
