//
//  LoginViewController.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/22.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet var googleSignInButton: GIDSignInButton!
    @IBOutlet var userNameStackView: UIStackView!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    
    let userManager = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        setupNavBar()
        setupViews()
    }
    
    @IBAction func onGoogleSignInButton() {
        AuthManager.signInWithGoogle(viewController: self) { uid in
            Task {
                do {
                    async let user = UserCRUD.getUser(uid: uid)
                    if let user = try await user {
                        //Is returning user
                        self.userManager.setUser(id: user.id)
                        self.dismiss(animated: true)
                    } else {
                        //Is new user
                        self.userManager.setUser(id: uid)
                        self.switchToUserNameView()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func onCreateAccountButton() {
        createAccount()
    }
    
    func createAccount() {
        guard let uid = userManager.id else { return }
        
        let userName = userNameTextField.text ?? ""
        Task {
            do {
                async let result = UserCRUD.createUser(user: User(id: uid, name: userName))
                if let _ = try await result {
                    self.dismiss(animated: true)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @objc func onCancelButton() {
        AuthManager.signOut()
        self.dismiss(animated: true)
    }
    
}

//TextField
extension LoginViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.removeBlanks() == "" {
            createAccountButton.isEnabled = false
        } else {
            createAccountButton.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createAccount()
        return true
    }
    
}

//UI
extension LoginViewController {
    func setupNavBar() {
        self.navigationItem.title = "ログイン"
        let backButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(onCancelButton))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupViews() {
        googleSignInButton.style = .wide
        googleSignInButton.isHidden = false
        userNameStackView.isHidden = true
        userNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        userNameTextField.returnKeyType = .done
    }
    
    func switchToUserNameView() {
        googleSignInButton.isHidden = true
        userNameStackView.isHidden = false
        createAccountButton.isEnabled = false
    }
}
