
import UIKit

@IBDesignable
class KMTextField: UITextField {
    
    var deleteBackwardAction: (() -> Void)?
    
    @IBInspectable var isCopyPasteEnabled: Bool = true {
        didSet {
            if !isCopyPasteEnabled {
                tintColor = .clear
            }
        }
    }
    
    @IBInspectable var changeWhenSelectedEnabled: Bool = true {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = Theme.Colors.themeDarkGrayLight {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var selectedBorderColor: UIColor = Theme.Colors.themeGreen {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var padding: CGFloat = 20 {
        didSet {
            updateView()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        defer { updateBorders() }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        defer { updateBorders() }
        return super.resignFirstResponder()
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding))
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding))
    }

    func updateView() {
        layer.borderWidth = 1
        layer.cornerRadius = 5
        updateBorders()
    }
    
    private func updateBorders() {
        if changeWhenSelectedEnabled {
            layer.borderColor = (isFirstResponder ? selectedBorderColor : borderColor).cgColor
        } else {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return isCopyPasteEnabled
    }
    
    override func deleteBackward() {
        if text?.isEmpty ?? false {
            deleteBackwardAction?()
        }
        super.deleteBackward()
    }
}
