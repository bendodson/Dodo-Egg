//
//  Bundle+IsProduction.swift
//  UKTV
//
//  Created by Benjamin Dodson on 22/06/2021.
//

import Foundation

extension Bundle {
    
    /// Is the app an App Store build (true) or a TestFlight, Ad Hoc, or Debug build (false)
    public var isProduction: Bool {
        #if DEBUG
            return false
        #else
            guard let path = self.appStoreReceiptURL?.path else { return true }
            return !path.contains("sandboxReceipt")
        #endif
    }
}
