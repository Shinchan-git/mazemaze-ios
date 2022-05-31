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
    @IBOutlet var tableView: UITableView!
    
    let userManager = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "MyListTableViewCell")
        setupNavBar()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = AuthManager.userId() {
            loginButton.isHidden = true
            tableView.isHidden = false
        } else {
            loginButton.isHidden = false
            tableView.isHidden = true
        }
    }
    
    @IBAction func onSignOutButton() {
        AuthManager.signOut()
    }
    
    @objc func onSettingButton() {
        self.performSegue(withIdentifier: "toSettingView", sender: nil)
    }
}

//TableView
extension MyListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as! MyListTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.setCell(text: "新規投稿を作成", image: UIImage(systemName: "plus")!)
        default:
            cell.setCell(text: "画集のタイトル", image: UIImage(systemName: "questionmark")!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "toNewPostView", sender: nil)
        default:
            print("Cell selected")
        }
    }
    
}

//UI
extension MyListViewController {
    
    func setupNavBar() {
        self.navigationItem.title = "マイリスト"
        let settingButton = UIBarButtonItem(title: "設定", style: .plain, target: self, action: #selector(onSettingButton))
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    func setupViews() {
        loginButton.isHidden = true
        tableView.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
    }
    
}
