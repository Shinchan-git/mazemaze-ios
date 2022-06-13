//
//  LoginViewController.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/22.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var googleSignInButton: GIDSignInButton!
    @IBOutlet var signInStackView: UIStackView!
    @IBOutlet var userNameStackView: UIStackView!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    
    var currentNonceForAppleSignIn: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        setupNavBar()
        setupViews()
    }
    
    @IBAction func onGoogleSignInButton() {
        AuthManager.signInWithGoogle(viewController: self) { uid in
            self.handleLoginCompleted(uid: uid)
        }
    }
    
    @IBAction func onAppleSignInButton() {
        currentNonceForAppleSignIn = AuthManager.signInWithApple(viewController: self)
    }
    
    func handleLoginCompleted(uid: String) {
        Task {
            do {
                async let user = UserCRUD.getUser(uid: uid)
                if let user = try await user {
                    //Is returning user, user document exists
                    print("Is returning user, user document exists")
                    UserManager.shared.setUser(id: user.id, name: user.name, blockUserIds: user.blockUserIds)
                    self.dismiss(animated: true)
                } else {
                    //Is new user, user document does not exist
                    print("Is new user, user document does not exist")
                    UserManager.shared.setUser(id: uid, blockUserIds: [])
                    self.switchToUserNameView()
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func onCreateAccountButton() {
        createAccount()
    }
    
    func createAccount() {
        guard let uid = UserManager.shared.id else { return }
        
        let userName = userNameTextField.text ?? ""
        Task {
            do {
                async let result = UserCRUD.createUser(user: User(id: uid, name: userName))
                if let _ = try await result {
                    UserManager.shared.setUser(id: uid, name: userName, blockUserIds: [])
                    self.dismiss(animated: true)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func onOpenTermsButton() {
        AuthManager.openTermsAndPrivacy()
    }
    
    @objc func onCancelButton() {
        AuthManager.signOut()
        self.dismiss(animated: true)
    }
    
}

//SignInWithApple
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        AuthManager.appleSignInController(authorization: authorization, currentNonce: currentNonceForAppleSignIn) { uid in
            self.handleLoginCompleted(uid: uid)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }

}


//TextField
extension LoginViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.removeBlanks() == "" {
            createAccountButton.isEnabled = false
            if #available(iOS 15.0, *) {} else {
                createAccountButton.backgroundColor = .tertiaryLabel
            }
        } else {
            createAccountButton.isEnabled = true
            if #available(iOS 15.0, *) {} else {
                createAccountButton.backgroundColor = .link
            }
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
        signInStackView.isHidden = false
        userNameStackView.isHidden = true
        userNameTextField.placeholder = "アカウントの表示名を入力"
        userNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        userNameTextField.returnKeyType = .done
        if #available(iOS 15.0, *) {} else {
            createAccountButton.backgroundColor = .tertiaryLabel
            createAccountButton.layer.cornerRadius = 6
            createAccountButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func switchToUserNameView() {
        signInStackView.isHidden = true
        userNameStackView.isHidden = false
        createAccountButton.isEnabled = false
    }
    
   
}
