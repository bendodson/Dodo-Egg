// Developed by Ben Dodson (ben@bendodson.com)

import Foundation
import os.log

extension OSLog {
    public static var subsystem = Bundle.main.bundleIdentifier!
    static let networking = OSLog(subsystem: subsystem, category: "networking")
}
