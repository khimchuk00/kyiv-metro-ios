
import UIKit

class PinCodeViewController: OffsetableViewController {
    
    override class var storyboard: Storyboard {
        return .pinCode
    }
    
    @IBOutlet weak var pinCodeTextField: KMTextField!
    @IBOutlet weak var checkPinCodeTextField: KMTextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var isFromRegistration: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPinCode()
        configureTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        if isFromRegistration {
            navigationController?.isNavigationBarHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.backItem?.title = "Профіль"
        }
    }
    
    private func configureTextField() {
        pinCodeTextField.delegate = self
        pinCodeTextField.addTarget(self, action: #selector(pinCodeFieldChanged), for: .editingChanged)
        checkPinCodeTextField.delegate = self
        checkPinCodeTextField.addTarget(self, action: #selector(pinCodeFieldChanged), for: .editingChanged)
    }
    
    private func setupContinueButton(enabled: Bool) {
        continueButton.isEnabled = enabled
    }

    // MARK: - Actions
    @IBAction func continuePressed() {
        if isFromRegistration {
            let vc = AddCardViewController.instantiate()
            vc.isFromRegistration = isFromRegistration
            navigationController?.pushViewController(vc, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}



// MARK: - UITextFieldDelegate

extension PinCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func pinCodeFieldChanged(_ textField: UITextField) {
        guard var pinCode = textField.text else {
            setupContinueButton(enabled: false)
            return
        }
        
        pinCode = modifiedPinCode(from: pinCode)
        textField.text = pinCode
        checkPinCode()
    }
    
    func textField (_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text
            else {
                return true
        }
        let newLenght = text.count + string.count - range.length
        return newLenght <= 13
    }
    
    private func modifiedPinCode(from code: String) -> String {
        let arrOfCharacters = Array(code.replacingOccurrences(of: " - ", with: ""))
        var modifiedCodeString = ""
        
        if arrOfCharacters.count > 0 {
            for i in 0...arrOfCharacters.count - 1 {
                modifiedCodeString.append(arrOfCharacters[i])
                if i + 1 != arrOfCharacters.count {
                    modifiedCodeString.append(" - ")
                }
            }
        }
        
        return modifiedCodeString
    }
    
    private func isPinCodeValid (code: String) -> Bool {
        let codeRegex = "^\\d{1} - \\d{1} - \\d{1} - \\d{1}$"
        let codeTest = NSPredicate(format: "SELF MATCHES %@", codeRegex)
        return codeTest.evaluate(with: code)
    }
    
    private func checkPinCode() {
        continueButton.isEnabled = pinCodeTextField.text == checkPinCodeTextField.text && isPinCodeValid(code: pinCodeTextField.text ?? "") && isPinCodeValid(code: checkPinCodeTextField.text ?? "")
    }
}
