//
//  MyListViewController.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/22.
//

import UIKit

class MyListViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isHidden = true
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthManager.isLoggedIn() {
            loginButton.isHidden = true
        } else {
            loginButton.isHidden = false
        }
    }
    
    @IBAction func onSignOut() {
        AuthManager.signOut()
    }
    
    func setupNavBar() {
        self.navigationItem.title = "マイリスト"
    }
    
}
