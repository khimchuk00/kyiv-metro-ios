//
//  KMAlertViewController.swift
//  kyiv-metro-ios
//
//  Created by Bohdan Dankovych on 18.12.2019.
//  Copyright © 2019 Movadex. All rights reserved.
//

import UIKit

typealias KMAlertVCButtonCompletion = (() -> Void)?

class KMAlertViewController: BaseViewController {
    
    override class var storyboard: Storyboard {
        return .common
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var handlersArray: [KMAlertVCButtonCompletion] = []
    var titles: [String] = []
    
    var error: String = ""
    var message: String = ""
    
    static func instantiate(error: String, message: String) -> KMAlertViewController {
        let vc = KMAlertViewController.instantiate()
        vc.error = error
        vc.message = message
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if handlersArray.count == 0 {
            addDefaultOkButton()
        }
        if handlersArray.count > 2 {
            buttonsStackView.axis = .vertical
        }
        
        errorLabel.text = error
        messageLabel.text = message
        configureButtons()
        configureContainer()
    }
    
    func addAction(title: String, completion: KMAlertVCButtonCompletion = nil) {
        handlersArray.append(completion)
        titles.append(title)
    }
    
    private func addDefaultOkButton() {
        handlersArray.append(nil)
        titles.append("OK")
    }
    
    private func configureButtons() {
        for i in 0..<handlersArray.count {
            let btn = KMButton()
            btn.tag = i
            btn.setTitle(titles[i], for: .normal)
            btn.buttonStyle = 1
            btn.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
            btn.heightAnchor.constraint(equalToConstant: 48).isActive = true
            buttonsStackView.addArrangedSubview(btn)
        }
    }
    
    override func viewDidLayoutSubviews() {
        configureContainer()
    }
    
    private func configureContainer() {
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        containerView.layer.shouldRasterize = true
    }
    
    @IBAction private func btnPressed(_ sender: UIButton) {
        if sender.tag >= 0 && sender.tag < handlersArray.count {
            handlersArray[sender.tag]?()
        }
        dismiss(animated: false)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
