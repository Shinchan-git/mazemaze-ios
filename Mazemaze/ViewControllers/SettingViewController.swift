//
//  SettingViewController.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/22.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }
    

    func setupNavBar() {
        self.navigationItem.title = "設定"
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(onCloseButton))
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func onCloseButton() {
        self.dismiss(animated: true)
    }

}
