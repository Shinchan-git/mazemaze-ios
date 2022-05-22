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
    
    @IBAction func onGoogleSignIn() {
        AuthManager.signInWithGoogle(viewController: self)
    }
    
    func setupNavBar() {
        self.navigationItem.title = "ログイン"
        let backButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupGoogleSignInButton() {
        googleSignInButton.style = .wide
    }
    
    @objc func cancel() {
        self.dismiss(animated: true)
    }
    
}
