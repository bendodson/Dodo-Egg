// Developed by Ben Dodson (ben@bendodson.com)

import UIKit

public protocol Presenter {
    func instance() -> UIViewController
    func instanceInNavigationController() -> UINavigationController
    func present(from viewController: UIViewController)
}

extension Presenter {
    public func instanceInNavigationController() -> UINavigationController {
        #warning("Need a way to import something like BaseNavigationController here")
        return UINavigationController(rootViewController: instance())
    }
    
    public func present(from viewController: UIViewController) {
        viewController.navigationController?.pushViewController(instance(), animated: true)
    }
}

