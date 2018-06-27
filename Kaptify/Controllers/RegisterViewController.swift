//
//  RegisterViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-06-24.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase


class RegisterViewController: UIViewController {
    
    let IMAGE_WIDTH: CGFloat = 235
    let IMAGE_HEIGHT: CGFloat = 268
    
    // MARK: Locking screen rotation
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: UI Elements to be added to View
    let loginCardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Login_image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
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
    
    let userUIView: UIView = {
        let userBG = UIView()
        userBG.backgroundColor = .white
        userBG.layer.cornerRadius = 5
        userBG.translatesAutoresizingMaskIntoConstraints = false
        return userBG
    }()
    
    let userTextField: UITextField = {
        let user = UITextField()
        user.backgroundColor = .white
        user.layer.cornerRadius = 5
        user.placeholder = "Username"
        user.translatesAutoresizingMaskIntoConstraints = false
        return user
    }()
    
    lazy var registerButton: UIButton = {
        let register = UIButton(type: .system) // shows button animation
        register.backgroundColor = UIColor(r: 28, b: 27, g: 27)
        register.setTitle("REGISTER", for: .normal)
        register.setTitleColor(.white, for: .normal)
        register.layer.cornerRadius = 20
        register.translatesAutoresizingMaskIntoConstraints = false
        
        register.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return register
    }()
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text, let password = passTextField.text else {
            print("Error: Invalid form")
            //TODO: Add popup view directing user to input valid fields
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, err) in
            if err != nil {
                print(err!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://kaptify-5a0af.firebaseio.com/")
            let usersRef = ref.child("Users").child(uid)
            let values = ["Email": email]
            
            usersRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error ?? "Error occured")
                    return
                }
            })
            /* Authentication successful, pop loginview */
            
        })
    }
    
    lazy var loginButton: UIButton = {
        let login = UIButton(type: .system)
        login.backgroundColor = UIColor(r: 28, b: 27, g: 27)
        login.setTitle("LOGIN", for: .normal)
        login.setTitleColor(.white, for: .normal)
        login.layer.cornerRadius = 20
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 51, b: 51, g: 51)
        setupViewsAndConstraints()

    }
    
    func setupViewsAndConstraints() {
        // add subviews
        view.addSubview(loginCardImage)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(emailUIView)
        view.addSubview(passUIView)
        view.addSubview(emailTextField)
        view.addSubview(passTextField)
        view.addSubview(userUIView)
        view.addSubview(userTextField)
        
        // setup constraints
        setupLoginCardImage()
        setupLoginButton()
        setupRegisterButton()
        setupEmailUIView()
        setupPassUIView()
        setupEmailTextField()
        setupPassTextField()
        setupUserUIView()
        setupUserTextField()
    }
    
    // MARK: Setup view constraints
    func setupUserTextField() {
        // x, y, width, height constraints
        userTextField.leftAnchor.constraint(equalTo: loginCardImage.leftAnchor, constant: 12).isActive = true
        userTextField.rightAnchor.constraint(equalTo: loginCardImage.rightAnchor, constant: -12).isActive = true
        userTextField.topAnchor.constraint(equalTo: loginCardImage.topAnchor, constant: 138).isActive = true
        userTextField.widthAnchor.constraint(equalToConstant: 185).isActive = true
        userTextField.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    func setupUserUIView() {
        // x, y, width, height constraints
        userUIView.leftAnchor.constraint(equalTo: loginCardImage.leftAnchor, constant: 8).isActive = true
        userUIView.rightAnchor.constraint(equalTo: loginCardImage.rightAnchor, constant: -8).isActive = true
        userUIView.topAnchor.constraint(equalTo: loginCardImage.topAnchor, constant: 138).isActive = true
        userUIView.widthAnchor.constraint(equalToConstant: 185).isActive = true
        userUIView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    func setupEmailUIView() {
        // x, y, width, height constraints
        emailUIView.leftAnchor.constraint(equalTo: loginCardImage.leftAnchor, constant: 8).isActive = true
        emailUIView.rightAnchor.constraint(equalTo: loginCardImage.rightAnchor, constant: -8).isActive = true
        emailUIView.topAnchor.constraint(equalTo: userUIView.bottomAnchor, constant: 12).isActive = true
        emailUIView.widthAnchor.constraint(equalToConstant: 185).isActive = true
        emailUIView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    func setupPassUIView() {
        // x, y, width, height constraints
        passUIView.leftAnchor.constraint(equalTo: loginCardImage.leftAnchor, constant: 8).isActive = true
        passUIView.rightAnchor.constraint(equalTo: loginCardImage.rightAnchor, constant: -8).isActive = true
        passUIView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12).isActive = true
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
    
    
    func setupRegisterButton() {
        // x, y, width, height constraints
        registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: loginCardImage.bottomAnchor, constant: 12).isActive = true
        registerButton.widthAnchor.constraint(equalTo: loginCardImage.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupLoginButton() {
        // x, y, width, height constraints
        loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalTo: loginCardImage.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupLoginCardImage() {
        // x, y, width, height constraints
        loginCardImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginCardImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 126).isActive = true
        loginCardImage.widthAnchor.constraint(equalToConstant: IMAGE_WIDTH).isActive = true
        loginCardImage.heightAnchor.constraint(equalToConstant: IMAGE_HEIGHT).isActive = true
    }
    

}
