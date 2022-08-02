// Developed by Ben Dodson (ben@bendodson.com)

import UIKit

public protocol ReusableCell {
    static func register(_ tableView: UITableView)
}

extension ReusableCell {
    
    public static func register(_ tableView: UITableView) {
        // Separating by < so we can catch generic implementations i.e. CardTableViewCell<Treasure>
        let identifier = String(describing: self)
        tableView.register(UINib(nibName: identifier.components(separatedBy: "<")[0], bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    public static func dequeue(_ tableView: UITableView, indexPath: IndexPath) -> Self {
        let identifier = String(describing: self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Self else {
            fatalError("Could not dequeue \(identifier)")
        }
        return cell
    }
    
}
