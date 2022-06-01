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
    
    var myPosts: [Post] = []
    var images: [UIImage?] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "MyListTableViewCell")
        setupNavBar()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let userId = UserManager.shared.id ?? AuthManager.userId() {
            loginButton.isHidden = true
            tableView.isHidden = false
            
            if let posts = MyPostManager.shared.posts {
                myPosts = posts
            } else {
                Task {
                    await loadMyPosts(userId: userId)
                }
            }
        } else {
            loginButton.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func loadMyPosts(userId: String) async {
        do {
            async let posts = PostCRUD.readPostByField(where: "senderId", isEqualTo: userId)
            if let posts = try await posts {
                myPosts = posts
                MyPostManager.shared.posts = posts
                tableView.reloadData()
                
                if let images = MyPostManager.shared.images {
                    self.images = images
                } else {
                    let docIds = myPosts.map { $0.id ?? "" }
                    print("docIds: \(docIds)")
                    await loadPostImages(userId: userId, docIds: docIds)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func loadPostImages(userId: String, docIds: [String]) async {
        for docId in docIds {
            do {
                let image = try await ImageCRUD.readImage(userId: userId, docId: docId)
                images.append(image)
            } catch {
                print(error)
            }
        }
        MyPostManager.shared.images = images
        tableView.reloadData()
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
        return myPosts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as! MyListTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.setCell(text: "新規投稿を作成", image: UIImage(systemName: "plus")!, imageViewContentMode: .center)
        default:
            let index = indexPath.row - 1
            let post = myPosts[index]
            let image = index < images.count ? images[index] : nil
            cell.setCell(text: post.title ?? "", image: image ?? UIImage(), imageViewContentMode: .scaleAspectFill)
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
