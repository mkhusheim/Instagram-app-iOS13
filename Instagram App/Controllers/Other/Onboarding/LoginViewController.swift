//
//  LoginViewController.swift
//  Instagram App
//
//  Created by Maram on 29/08/1442 AH.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    // Constants
    struct K {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let usernameEmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username or Email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = K.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        field.returnKeyType = .continue // to login button
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = K.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = K.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of service", for: .normal)
        button.layer.masksToBounds = true
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.layer.masksToBounds = true
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("New User? Create an Account", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named:"gradient"))
        header.addSubview(backgroundImageView)
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add target to our buttons to connect to their functions
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        
        // Set UsernameEmailField delegate
        usernameEmailField.delegate = self
        
        addSubviews()
        
        // Set background color
        view.backgroundColor = .systemBackground
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Assign frames
        headerView.frame = CGRect(x: 0,
                                  y: 0.0, // ignores safearea
                                  width: view.width,
                                  height: view.height/3.0)
        usernameEmailField.frame = CGRect(x: 25,
                                          y: headerView.bottom + 40, // +10 away from headerview
                                          width: view.width - 50, // centered
                                          height: 52.0)
        passwordField.frame = CGRect(x: 25,
                                     y: usernameEmailField.bottom + 10, // +10 away from usernameEmailField
                                     width: view.width - 50, // centered
                                     height: 52.0)
        loginButton.frame = CGRect(x: 25,
                                   y: passwordField.bottom + 10, // +10 away from usernameEmailField
                                   width: view.width - 50, // centered
                                   height: 52.0)
        createAccountButton.frame = CGRect(x: 25,
                                           y: loginButton.bottom + 10, // +10 away from usernameEmailField
                                           width: view.width - 50, // centered
                                           height: 52.0)
        
        termsButton.frame = CGRect(x: 10,
                                   y: view.height - view.safeAreaInsets.bottom - 100,
                                   width: view.width - 20, // centered
                                   height: 50)
        
        privacyButton.frame = CGRect(x: 10,
                                     y: view.height - view.safeAreaInsets.bottom - 50,
                                     width: view.width - 20, // centered
                                     height: 50)
        
        configureHeaderView()
        
        // Add instagram logo
        let imageView = UIImageView(image: UIImage(named:"logo"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x:headerView.width/4.0, y: view.safeAreaInsets.top,
                                 width: headerView.width/2.0,
                                 height: headerView.height - view.safeAreaInsets.top)
    }
    
    private func configureHeaderView () {
        guard headerView.subviews.count == 1 else {
            return
        }
        guard let backgroundView = headerView.subviews.first else {
            return
        }
        backgroundView.frame = headerView.bounds
    }
    
    private func addSubviews() {
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(createAccountButton)
        view.addSubview(headerView)
        
    }
    @objc private func didTapLoginButton () {
        // dismiss keyboard for all fields
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        
        // Get fields content & validate
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        // Login functionality
        // Email or username validation
        var email: String?
        var username: String?
        if usernameEmail.contains("@"), usernameEmail.contains("."){
            // email
            email = usernameEmail
        } else {
            // username
            username = usernameEmail
        }
        AuthManager.shared.loginUser(username: username, email: email, password: password) { (success) in
            // Important: This closure is called a background thread, we need to adjust on UI > need Dispatch
            DispatchQueue.main.async {
                if success {
                    // user logged in
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // error occurred
                    // display alert
                    let alert = UIAlertController(title: "Login Error", message: "We are unable to log you in.", preferredStyle: .alert)
                    // add dismiss button
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    // present alert
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
    
    @objc private func didTapTermsButton () {
        guard let url = URL(string: "https://help.instagram.com/1215086795543252") else {
            return
        }
        // Open instagram terms in a webview
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapPrivacyButton () {
        guard let url = URL(string: "https://help.instagram.com/519522125107875") else {
            return
        }
        // Open instagram privacy in a webview
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapCreateAccountButton () {
        // Navigate to registration view controller
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        present(UINavigationController(rootViewController: vc), animated: true)
        // present(vc, animated: true, completion: nil)
        // or just present (vc, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapLoginButton()
        }
        return true
    }
}
