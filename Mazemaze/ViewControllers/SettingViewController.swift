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
    
    func toProfileSettingView() {
        self.performSegue(withIdentifier: "toProfileSettingView", sender: nil)
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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell

        switch indexPath.section {
        case 0:
            cell.setCell(text: "プロフィール")
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            cell.setCell(text: "ログアウト", color: .red)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            toProfileSettingView()
        case 1:
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
