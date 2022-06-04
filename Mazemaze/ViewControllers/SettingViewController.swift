//
//  SettingViewController.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/22.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    var didSignOut: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        setupNavBar()
    }
    
    func onSignOutCell() {
        AuthManager.signOut()
        UserManager.shared.setUser(id: nil, name: nil)
        MyPostManager.shared.myPosts = nil
        MyPostManager.shared.myTags = nil
        RecommendedPostManager.shared.posts = nil
        didSignOut?()
        self.dismiss(animated: true)
    }
    
    @objc func onCloseButton() {
        self.dismiss(animated: true)
    }

}

//TableView
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.setCell(text: "ログアウト", color: .red)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            onSignOutCell()
        default:
            print("Cell selected")
        }
    }
    
}

//UI
extension SettingViewController {
    
    func setupNavBar() {
        self.navigationItem.title = "設定"
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(onCloseButton))
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
}
