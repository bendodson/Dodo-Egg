// Created by Ben Dodson (ben@bendodson.com)

import Foundation

extension Bundle {
    
    /// App Version i.e. 2.0.1
    var version: String {
        var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return version
    }
    
    /// Bundle Number i.e. 1
    var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
