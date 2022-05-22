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
    
    @IBAction func onSignOutButton() {
        AuthManager.signOut()
    }
    
    func setupNavBar() {
        self.navigationItem.title = "マイリスト"
        let settingButton = UIBarButtonItem(title: "設定", style: .plain, target: self, action: #selector(onSettingButton))
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    @objc func onSettingButton() {
        self.performSegue(withIdentifier: "toSettingView", sender: nil)
    }
}
