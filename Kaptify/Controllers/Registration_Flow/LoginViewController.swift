//
//  LoginViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-06-27.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let IMAGE_WIDTH: CGFloat = 235
    let IMAGE_HEIGHT: CGFloat = 268
    let CANCEL_WIDTH: CGFloat = 64
    let CANCEL_HEIGHT: CGFloat = 64
    
    // MARK: UI Elements to be added to View
    let cancelButton: UIButton = {
        let cancel = UIButton()
        let xImage = UIImage(named: "Cancel_btn")
        let xImageView = UIImageView(image: xImage)
        xImageView.contentMode = .scaleAspectFill
        cancel.setImage(xImageView.image, for: .normal)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
        return cancel
    }()
    
    @objc func handleCancel() {
        dismissViewsOnSuccess()
    }
    
    let loginCardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Login_image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailUIView: UIView = {
        let emailBG = UIView()
        emailBG.backgroundColor = .white
        emailBG.layer.cornerRadius = 5
        emailBG.translatesAutoresizingMaskIntoConstraints = false
        return emailBG
    }()
    
    let passUIView: UIView = {
        let passBG = UIView()
        passBG.backgroundColor = .white
        passBG.layer.cornerRadius = 5
        passBG.translatesAutoresizingMaskIntoConstraints = false
        return passBG
    }()
    
    let emailTextField: UITextField = {
        let email = UITextField()
        email.backgroundColor = .white
        email.layer.cornerRadius = 5
        email.placeholder = "Email"
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    let passTextField: UITextField = {
        let pass = UITextField()
        pass.backgroundColor = .white
        pass.layer.cornerRadius = 5
        pass.isSecureTextEntry = true
        pass.placeholder = "Password"
        pass.translatesAutoresizingMaskIntoConstraints = false
        return pass
    }()
    
    lazy var loginButton: UIButton = {
        let login = UIButton(type: .system) // shows button animation
        login.backgroundColor = UIColor(r: 28, b: 27, g: 27)
        login.setTitle("LOGIN", for: .normal)
        login.setTitleColor(.white, for: .normal)
        login.layer.cornerRadius = 20
        login.translatesAutoresizingMaskIntoConstraints = false
        
        /*TODO: */
        login.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return login
    }()
    
    @objc func handleLogin () {
        guard let email = emailTextField.text, let password = passTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error ?? "Login error")
                return
            }
            self.dismissViewsOnSuccess()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 51, b: 51, g: 51)
        setupViewsAndConstraints()
//        if Auth.auth().currentUser?.uid == nil {
//            cancelButton.isHidden = true
//        }
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupViewsAndConstraints() {
        // Add subviews to view

        self.view.addSubview(cancelButton)
        self.view.addSubview(loginCardImage)
        self.view.addSubview(loginLabel)
        self.view.addSubview(emailUIView)
        self.view.addSubview(passUIView)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passTextField)
        self.view.addSubview(loginButton)
        
        
        // Add constraints to subviews
        setupCancelButton()
        setupLoginCardImage()
        setupLoginLabel()
        setupEmailUIView()
        setupPassUIView()
        setupEmailTextField()
        setupPassTextField()
        setupLoginButton()
    }
    
    func setupCancelButton() {
        // x, y, width, height constraints
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: CANCEL_WIDTH).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: CANCEL_HEIGHT).isActive = true
    }
    
    func setupLoginCardImage() {
        // x, y, width, height constraints
        loginCardImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginCardImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
        loginCardImage.widthAnchor.constraint(equalToConstant: IMAGE_WIDTH).isActive = true
        loginCardImage.heightAnchor.constraint(equalToConstant: IMAGE_HEIGHT).isActive = true
    }
    
    func setupLoginLabel() {
        // x, y, width, height constraints
        loginLabel.leftAnchor.constraint(equalTo: loginCardImage.leftAnchor, constant: 8).isActive = true
        loginLabel.rightAnchor.constraint(equalTo: loginCardImage.rightAnchor, constant: -12).isActive = true
        loginLabel.bottomAnchor.constraint(equalTo: emailUIView.topAnchor, constant: -8).isActive = true
        loginLabel.widthAnchor.constraint(equalToConstant: 185).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    func setupEmailUIView() {
        // x, y, width, height constraints
        emailUIView.leftAnchor.constraint(equalTo: loginCardImage.leftAnchor, constant: 8).isActive = true
        emailUIView.rightAnchor.constraint(equalTo: loginCardImage.rightAnchor, constant: -8).isActive = true
        emailUIView.topAnchor.constraint(equalTo: loginCardImage.topAnchor, constant: 178).isActive = true
        emailUIView.widthAnchor.constraint(equalToConstant: 185).isActive = true
        emailUIView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    func setupPassUIView() {
        // x, y, width, height constraints
        passUIView.leftAnchor.constraint(equalTo: loginCardImage.leftAnchor, constant: 8).isActive = true
        passUIView.rightAnchor.constraint(equalTo: loginCardImage.rightAnchor, constant: -8).isActive = true
        passUIView.topAnchor.constraint(equalTo: emailUIView.bottomAnchor, constant: 12).isActive = true
        passUIView.widthAnchor.constraint(equalToConstant: 185).isActive = true
        passUIView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    func setupEmailTextField() {
        // x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: loginCardImage.leftAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: loginCardImage.rightAnchor, constant: -12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: loginCardImage.topAnchor, constant: 178).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 185).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    func setupPassTextField() {
        // x, y, width, height constraints
        passTextField.leftAnchor.constraint(equalTo: loginCardImage.leftAnchor, constant: 12).isActive = true
        passTextField.rightAnchor.constraint(equalTo: loginCardImage.rightAnchor, constant: -12).isActive = true
        passTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12).isActive = true
        passTextField.widthAnchor.constraint(equalToConstant: 185).isActive = true
        passTextField.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    func setupLoginButton() {
        // x, y, width, height constraints
        loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: loginCardImage.bottomAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: IMAGE_WIDTH - 5).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

extension LoginViewController {
    func dismissViewsOnSuccess() {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
