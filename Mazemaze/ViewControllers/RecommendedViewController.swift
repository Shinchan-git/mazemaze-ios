//
//  RecommendedViewController.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/22.
//

import UIKit

class RecommendedViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    
    let userManager = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        loginButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = AuthManager.userId() {
            loginButton.isHidden = true
        } else {
            loginButton.isHidden = false
        }
        
        print("userManager.id: \(userManager.id ?? "")")
    }
    
    func setupNavBar() {
        self.navigationItem.title = "おすすめ"
    }
    
}
