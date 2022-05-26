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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupGoogleSignInButton()
    }
    
    @IBAction func onGoogleSignInButton() {
        AuthManager.signInWithGoogle(viewController: self) { uid in
            Task {
                do {
                    async let user = UserCRUD.getUser(uid: uid)
                    if let user = try await user {
                        //Is returning user
                        print("Is returning user, id: \(user.id)")
                    } else {
                        //Is new user
                        print("Is new user")
                        UserCRUD.createUser(user: User(id: uid))
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func setupNavBar() {
        self.navigationItem.title = "ログイン"
        let backButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(onCancelButton))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupGoogleSignInButton() {
        googleSignInButton.style = .wide
    }
    
    @objc func onCancelButton() {
        self.dismiss(animated: true)
    }
    
}
