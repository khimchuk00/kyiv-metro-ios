
import UIKit

class ConfirmationCodeViewController: OffsetableViewController {
    
    override class var storyboard: Storyboard {
        return .auth
    }
    
    @IBOutlet weak var confirmationCodeTextField: KMTextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContinueButton(enabled: false)
        configureTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = "Реєстрація"
    }
    
    private func configureTextField() {
        confirmationCodeTextField.delegate = self
        confirmationCodeTextField.addTarget(self, action: #selector(confirmationFieldChanged), for: .editingChanged)
    }
    
    private func setupContinueButton(enabled: Bool) {
        continueButton.isEnabled = enabled
    }
    
    // MARK: - Actionss
    @IBAction func continuePressed() {
        showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hideHUD()
            let vc = PinCodeViewController.instantiate()
            vc.isFromRegistration = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ConfirmationCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc private func confirmationFieldChanged() {
        guard var codeText = confirmationCodeTextField.text else {
            setupContinueButton(enabled: false)
            return
        }
        
        codeText = modifiedConfirmCode(from: codeText)
        confirmationCodeTextField.text = codeText
        setupContinueButton(enabled: isCodeValid(code: codeText))
    }
    
    func textField( _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let newLength = text.count + string.count - range.length
        return newLength <= 9
    }
    
    private func modifiedConfirmCode(
        from code: String) -> String {
        
        let arrOfCharacters = Array(code.replacingOccurrences(of: " ", with: ""))
        var modifiedCodeString = ""
        
        if arrOfCharacters.count > 0 {
            for i in 0...arrOfCharacters.count - 1 {
                modifiedCodeString.append(arrOfCharacters[i])
                if i + 1 != arrOfCharacters.count {
                    modifiedCodeString.append(" ")
                }
            }
        }
        
        return modifiedCodeString
    }

    private func isCodeValid (code: String) -> Bool {
        let codeRegex = "^\\d{1} \\d{1} \\d{1} \\d{1} \\d{1}$"
        let codeTest = NSPredicate(format: "SELF MATCHES %@", codeRegex)
        return codeTest.evaluate(with: code)
    }

}

