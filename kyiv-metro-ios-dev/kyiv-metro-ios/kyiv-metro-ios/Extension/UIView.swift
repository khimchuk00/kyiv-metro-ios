

import UIKit

extension UIView {
    var globalFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}
