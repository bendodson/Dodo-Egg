// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

extension ProcessInfo {
    public var isRunningTest: Bool {
        return environment["IS_RUNNING_TEST"] == "YES"
    }
}
