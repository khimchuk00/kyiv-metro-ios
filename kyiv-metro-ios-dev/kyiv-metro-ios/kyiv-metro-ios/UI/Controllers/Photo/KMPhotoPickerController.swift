
import UIKit
import JGProgressHUD

class KMPhotoPickerController: UIImagePickerController {
    
    var takePhotoButton: UIButton!
    var actionHud: JGProgressHUD?
    
    lazy var hudContainerView: UIView = {
        let screenSize = UIScreen.main.bounds.size
        let height: CGFloat = 200
        let containerView = UIView(frame: CGRect(x: 0, y: screenSize.height - height, width: screenSize.width, height: height))
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCamaraView()
    }
    
    func configure() {
        sourceType = .camera
        cameraDevice = .front
        cameraCaptureMode = .photo
        showsCameraControls = false
        allowsEditing = true
    }
    
    private func configureCamaraView() {
        let screenSize = UIScreen.main.bounds.size
        let ratio: CGFloat = 4.0 / 3.0
        let cameraHeight: CGFloat = screenSize.width * ratio
        let scale: CGFloat = screenSize.height / cameraHeight

        cameraViewTransform = CGAffineTransform(translationX: 0, y: (screenSize.height - cameraHeight) / 2.0)
        cameraViewTransform = cameraViewTransform.scaledBy(x: scale, y: scale)
    }
    
    private func configureView() {
        addTakePhotoButton()
        addBackButton()
        addFaceBorderView()
    }
    
    private func addTakePhotoButton() {
        let screenSize = UIScreen.main.bounds.size
        
        takePhotoButton = UIButton(frame: CGRect(x: screenSize.width / 2 - 32, y: screenSize.height - 114, width: 64, height: 64))
        
        takePhotoButton.setImage(UIImage(named: "camera-img"), for: .normal)
        takePhotoButton.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        
        view.addSubview(takePhotoButton)
    }
    
    private func addBackButton() {
        let backButton = UIButton(frame: CGRect(x: 16, y: 50, width: 48, height: 44))
        
        backButton.setImage(UIImage(named: "back-img"), for: .normal)
        backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        view.addSubview(backButton)
    }
    
    private func addFaceBorderView() {
        let screenSize = UIScreen.main.bounds.size
        
        let faceBorderImageView = UIImageView(frame: CGRect(x: screenSize.width / 2 - 140, y: 100, width: 280, height: 402))
        faceBorderImageView.image = UIImage(named: "face-border-img")
        view.addSubview(faceBorderImageView)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    // MARK: - HUD
    
    func showHUD() {
        view.isUserInteractionEnabled = false
        takePhotoButton.isHidden = true
        actionHud = Theme.showHudProgress(in: self.hudContainerView, msg: "Проводиться перевірка")
    }
    
    func hideHUD() {
        view.isUserInteractionEnabled = true
        takePhotoButton.isHidden = false
        if let hud = actionHud {
            hud.dismiss(animated: false)
        }
    }
}
