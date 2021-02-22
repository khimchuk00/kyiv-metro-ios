
import UIKit
import JGProgressHUD
import RPCircularProgress

//swiftlint:disable force_unwrapping
class Theme {
    
    struct Colors {
        static let themeWhite = UIColor(hex: "#FFFFFF")!
        //Gray
        static let themeLightGray = UIColor(hex: "#EFEFF4")!
        static let themeGray = UIColor(hex: "#E5E5EA")!
        static let themeDarkGray = UIColor(hex: "#666666")!
        static let themeDarkGrayLight = UIColor(hex: "#C7C7CC")!
        static let themeMidGray = UIColor(hex: "#D1D1D6")!
        //
        static let themeBlack = UIColor(hex: "#000000")!
        static let themeGreen = UIColor(hex: "#33AA52")!
        static let themeGreenDisabled = UIColor(hex: "#6BBC80")!
        static let themeBlue = UIColor(hex: "#344972")!
        static let themeRed = UIColor(hex: "#EB5757")!
        
    }
    
    struct Fonts {
        
        enum FontMode: String {
            case bold = "Bold"
            case regular = "Regular"
            case italic = "Italic"
            case semibold = "Semibold"
        }
        
        private static let titleDisplayFontName = "SFProDisplay"
        private static let titleTextFontName = "SFProText"
        
        static func themeFont(size: CGFloat = 17, mode: FontMode = .regular) -> UIFont {
            return UIFont(name: titleTextFontName + "-" + mode.rawValue, size: size)!
        }
        
        static func themeTitleFont(size: CGFloat = 24, mode: FontMode = .regular) -> UIFont {
            return UIFont(name: titleDisplayFontName + "-" + mode.rawValue, size: size)!
        }
    }
}

// MARK: - ProgressHUD
extension Theme {
    
    class KMIndeterminateProgressView: JGProgressHUDIndicatorView {
        
        var circularView: RPCircularProgress?
        
        init() {
            circularView = RPCircularProgress()
            circularView?.thicknessRatio = 0.15
            circularView?.enableIndeterminate()
            circularView?.progressTintColor = Theme.Colors.themeGreen
            circularView?.trackTintColor = .clear
            
            if let aView = circularView {
                super.init(contentView: aView)
            } else {
                super.init(contentView: nil)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    @discardableResult
    static func showHudProgress(in view: UIView, msg: String? = nil) -> JGProgressHUD {
        let hud = JGProgressHUD(style: .extraLight)
        hud.indicatorView = KMIndeterminateProgressView()
        
        if let aMsg = msg {
            let attriburedMessage = NSAttributedString(string: aMsg, attributes: [
                .font: Fonts.themeFont(size: 16),
                .foregroundColor: Colors.themeDarkGray
            ])
            hud.textLabel.attributedText = attriburedMessage
        }
        hud.show(in: view, animated: true)
        return hud
    }
}

//swiftlint:enable force_unwrapping
