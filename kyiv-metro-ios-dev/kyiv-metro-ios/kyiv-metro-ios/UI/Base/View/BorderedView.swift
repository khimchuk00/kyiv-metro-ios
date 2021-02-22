
import UIKit

@IBDesignable
class BorderedView: UIView {
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            updateBorders()
        }
    }
    
    @IBInspectable var borderColor: UIColor = Theme.Colors.themeGreen {
        didSet {
            updateBorders()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            updateBorders()
        }
    }
    
    func updateBorders() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }
}
