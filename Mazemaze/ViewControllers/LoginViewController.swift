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
        AuthManager.signInWithGoogle(viewController: self)
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
