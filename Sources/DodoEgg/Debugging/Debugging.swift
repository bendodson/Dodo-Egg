// Developed by Ben Dodson (ben@bendodson.com)

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import Willow

@available(*, deprecated)
typealias SageOfDebugging = Debugging

public struct Debugging {
    
    public static var shared = Debugging()
    
    public var injectedLogWriters: [LogWriter] = []
    
    public lazy var logger: Willow.Logger = {
        var writers = [LogWriter]()
        #if DEBUG
            writers.append(SageConsoleWriter())
        #endif
        writers.append(contentsOf: injectedLogWriters)
        return Logger(logLevels: [.all], writers: writers)
    }()
    
    public lazy var device: String = {
        #if os(macOS)
        return "v\(Bundle.main.version) (\(Bundle.main.buildNumber)) | macOS \(ProcessInfo.processInfo.operatingSystemVersion) | \(Bundle.main.modelIdentifier)"
        #else
        return "v\(Bundle.main.version) (\(Bundle.main.buildNumber)) | \(UIDevice.current.systemName) \(UIDevice.current.systemVersion) | \(Bundle.main.modelIdentifier)"
        #endif
    }()
    
    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return formatter
    }()
    
    public static func log(_ category: DebugCategory, level: DebugLogLevel, message: String = "", userInfo: [String: Any] = [:], file: String = #file, line: Int = #line) {
        
        shared.logger.logMessage({
            let codepath = "\((file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")):\(line)"
            return DebugLog(category: category.rawValue, level: level, message: message, userInfo: userInfo, codepath: codepath)
        }, with: level.toWillow())
    }
    
    public static func log(_ category: DebugCategory, error: Error, userInfo: [String: Any] = [:], file: String = #file, line: Int = #line) {
        let message = "\(error)"
        log(category, level: .error, message: message, userInfo: userInfo, file: file, line: line)
    }
}

extension DebugLogLevel {
    func toWillow() -> Willow.LogLevel {
        switch self {
        case .debug:
            return .debug
        case .info:
            return .info
        case .event:
            return .event
        case .warn:
            return .warn
        case .error:
            return .error
        }
    }
}

public struct DebugCategory: RawRepresentable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static let app = DebugCategory(rawValue: "app")
    public static let ui = DebugCategory(rawValue: "ui")
    public static let networking = DebugCategory(rawValue: "networking")
}

public enum DebugLogLevel: String {
    case debug
    case info
    case event
    case warn
    case error
}

public struct DebugLog {
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

extension DebugLog: LogMessage {
    public var name: String {
        return category
    }
    
    public var attributes: [String: Any] {
        return [:]
    }
}

class SageConsoleWriter: LogWriter {
    func writeMessage(_ message: String, logLevel: Willow.LogLevel) {
        fatalError("Do not write messages to SageConsoleWriter... use SageMessage")
    }
    
    func writeMessage(_ message: Willow.LogMessage, logLevel: Willow.LogLevel) {
        guard let log = message as? DebugLog else { return }
        var components = [String]()
        components.append("🪶")
        components.append(Debugging.shared.dateFormatter.string(from: log.date))
        components.append("[\(log.category)]")
        if logLevel == .error || logLevel == .warn {
            components.append("⚠️")
        }
        if !log.message.isEmpty {
            components.append(log.message)
        }
        if !log.userInfo.isEmpty {
            components.append("\(log.userInfo)")
        }
        components.append("(\(log.codepath))")
        let string = components.joined(separator: " ")
        print(string)
    }
}
