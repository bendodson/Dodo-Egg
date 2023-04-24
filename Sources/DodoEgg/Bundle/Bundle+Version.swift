// Created by Ben Dodson (ben@bendodson.com)

import Foundation

extension Bundle {
    
    /// App Version i.e. 2.0.1
    public var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    /// Bundle Number i.e. 1
    public var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
