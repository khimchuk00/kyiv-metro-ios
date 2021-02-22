

import UIKit

extension UIView {
    
    class func loadViewFromNib<T>(owner: Any? = nil) -> T? where T: UIView {
        
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        let view = nib.instantiate(withOwner: owner, options: nil).first as? T
        
        return view
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type, nibName: String? = nil, customIdentifier: String? = nil) {
        let identifier = customIdentifier ?? "\(cellType)"
        let cellnibName = nibName ?? "\(cellType)"
        let nib = UINib(nibName: cellnibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func cell<T: UITableViewCell>(cellType: T.Type, nibName: String? = nil, identifier: String? = nil) -> T {
        let identifier = identifier ?? "\(cellType)"
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
            print("cell own type")
            return T.loadViewFromNib() ?? T()
        }
        
        return cell
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellType: T.Type, nibName: String? = nil) {
        let identifier = "\(cellType)"
        let cellnibName = nibName ?? "\(cellType)"
        let nib = UINib(nibName: cellnibName, bundle: nil)
        self.register(cellType, forCellWithReuseIdentifier: identifier)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func cell<T: UICollectionViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "\(cellType)", for: indexPath) as? T else {
            return T()
        }
        
        return cell
    }
    
}
