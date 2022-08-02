// Developed by Ben Dodson (ben@bendodson.com)

import UIKit

open class BaseViewController: UIViewController {
    
    @objc public func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
}
