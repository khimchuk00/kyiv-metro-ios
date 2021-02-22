
import UIKit

class AuthViewController: OffsetableViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var changeStateButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainButton: KMButton!
    @IBOutlet weak var headerImageView: UIImageView!
    
    override class var storyboard: Storyboard {
        return .auth
    }
    
    var state = AuthState.login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerImageView.image = headerImageView.image?.alpha(0.1)
        setupMainButton(enabled: false)
        configureTextField()
        configureView()
    }
    
    override func offsetableTextFields() -> [UITextField] {
        return [phoneTextField]
    }
    
    private func configureView() {
        navigationController?.isNavigationBarHidden = true
        titleLabel.text = state.controllerTitle
        mainButton.setTile(title: state.mainButtonTitle)
        changeStateButton.setAttributedTitle(state.changeStateButtonTitle, for: .normal)
    }
    
    private func configureTextField() {
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(phoneFieldChanged), for: .editingChanged)
    }
    
    private func changeState() {
        switch state {
        case .login:
            state = .register
        case .register:
            state = .login
        }
        
        configureView()
    }
    
    private func setupMainButton(enabled: Bool) {
        mainButton.isEnabled = enabled
    }
    
    // MARK: - Actions
    
    @IBAction func mainButtonPressed() {
        switch state {
        case .login:
            let vc = EnterPinCodeViewController.instantiate()
            vc.phoneNumber = phoneTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
            showHUD()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hideHUD()
                self.present(vc, animated: true)
            }
        case .register:
            let vc = ConfirmationCodeViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func changeStatePressed() {
        changeState()
    }
}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func phoneFieldChanged() {
        guard var phoneText = phoneTextField.text else {
            setupMainButton(enabled: false)
            return
        }
        
        phoneText = modifiedPhoneNumber(from: phoneText)
        phoneTextField.text = phoneText
        setupMainButton(enabled: isPhoneNumberValid(number: phoneText))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        return newLength <= 13
    }
    
    private func modifiedPhoneNumber(from phone: String) -> String {
        
        let arrOfCharacters = Array(phone.replacingOccurrences(of: " ", with: ""))
        var modifiedPhoneString = ""
        
        if arrOfCharacters.count > 0 {
            for i in 0...arrOfCharacters.count - 1 {
                modifiedPhoneString.append(arrOfCharacters[i])
                if [2, 5, 7].contains(i) && i + 1 != arrOfCharacters.count {
                    modifiedPhoneString.append(" ")
                }
            }
        }
        
        return modifiedPhoneString
    }
    
    private func isPhoneNumberValid(number: String) -> Bool {
        let phoneRegex = "^\\d{3} \\d{3} \\d{2} \\d{2}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: number)
    }
}

// MARK: - Auth State

extension AuthViewController {
    enum AuthState {
        case register
        case login
        
        var controllerTitle: String {
            switch self {
            case .login:
                return "Вхід"
            case .register:
                return "Реєстрація"
            }
        }
        
        var mainButtonTitle: String {
            switch self {
            case .login:
                return "Увійти"
            case .register:
                return "Зареєструватись"
            }
        }
        
        var changeStateButtonTitle: NSAttributedString {
            switch self {
            case .login:
                let attrTitle = NSMutableAttributedString(string: "Не маєте аккаунта?", attributes: [
                    .foregroundColor: Theme.Colors.themeDarkGray,
                    .font: Theme.Fonts.themeFont(size: 15)
                ])
                
                attrTitle.append(NSAttributedString(string: " Створіть новий", attributes: [
                    .foregroundColor: Theme.Colors.themeGreen,
                    .font: Theme.Fonts.themeFont(size: 15, mode: .semibold)
                ]))
                
                return attrTitle
            case .register:
                return NSAttributedString(string: "Вже маєте аккаунт?", attributes: [
                    .foregroundColor: Theme.Colors.themeGreen,
                    .font: Theme.Fonts.themeFont(size: 15, mode: .semibold)
                ])
            }
        }
    }
}
