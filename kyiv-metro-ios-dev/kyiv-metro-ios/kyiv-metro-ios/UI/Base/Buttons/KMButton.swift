import UIKit

@IBDesignable
class KMButton: UIButton {
    
    @IBInspectable
    var buttonStyle: Int {
        get {
            return style.rawValue
        }
        set(newValue) {
            style = Style(rawValue: newValue) ?? .filled
            configure()
        }
    }
    
    private var style: Style = .filled
    
    enum Style: Int {
        case filled
        case plain
        case bordered
    }
    
    override var isEnabled: Bool {
        didSet {
            self.configure()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    private func configure() {
        
        layer.cornerRadius = 5
        layer.borderWidth = 0
        
        if isEnabled {
            backgroundColor = style == .filled ? Theme.Colors.themeGreen : .clear
        } else {
            backgroundColor = style == .filled ? Theme.Colors.themeGreenDisabled : .clear
        }
        
        guard let title = title(for: .normal) else { return }
        setTile(title: title)
    }
    
    func setTile(title: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let titleString: NSAttributedString
        switch style {
        case .filled:
            titleString = NSAttributedString(string: title, attributes: [
                .font: Theme.Fonts.themeFont(mode: .semibold),
                .foregroundColor: Theme.Colors.themeWhite
            ])
            
            tintColor = isEnabled ? Theme.Colors.themeGreen : Theme.Colors.themeDarkGray
        case .plain:
            titleString = NSAttributedString(string: title, attributes: [
                .font: Theme.Fonts.themeFont(mode: .semibold),
                .foregroundColor: isEnabled ? Theme.Colors.themeGreen : Theme.Colors.themeDarkGray
            ])
            
            tintColor = isEnabled ? Theme.Colors.themeGreen : Theme.Colors.themeDarkGray
        case .bordered:
            titleString = NSAttributedString(string: title, attributes: [
                .font: Theme.Fonts.themeFont(mode: .semibold),
                .foregroundColor: Theme.Colors.themeDarkGray
            ])
            layer.borderWidth = 1
            layer.borderColor = Theme.Colors.themeDarkGray.cgColor
        }
        
        setAttributedTitle(titleString, for: .normal)
    }
}
