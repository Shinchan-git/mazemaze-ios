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

    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "MyListTableViewCell")
        setupNavBar()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userId = UserManager.shared.id ?? AuthManager.userId() {
            loginButton.isHidden = true
            tableView.isHidden = false
            
            if let myPosts = MyPostManager.shared.myPosts {
                MyPostManager.shared.myPosts = myPosts
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
        print("Load my posts")
        do {
            async let posts = PostCRUD.readPostByField(where: "senderId", isEqualTo: userId)
            if let posts = try await posts {
                let myPosts = posts.map { MyPost(post: $0, image: nil) }
                MyPostManager.shared.myPosts = myPosts
                tableView.reloadData()
                await loadPostImages(userId: userId, myPosts: myPosts)
            }
        } catch {
            print(error)
        }
    }
    
    func loadPostImages(userId: String, myPosts: [MyPost]) async {
        for (index, myPost) in myPosts.enumerated() {
            let docId = myPost.post?.id ?? ""
            do {
                let image = try await ImageCRUD.readImage(userId: userId, docId: docId)
                MyPostManager.shared.myPosts?[index].image = image
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
    }
    
    func callBack() {
        tableView.reloadData()
    }
    
    @IBAction func onSignOutButton() {
        AuthManager.signOut()
    }
    
    @objc func onSettingButton() {
        self.performSegue(withIdentifier: "toSettingView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewPostView" {
            let navigationController = segue.destination as! UINavigationController
            let newPostViewController = navigationController.topViewController as! NewPostViewController
            newPostViewController.completion = { self.callBack() }
        }
    }
    
}

//TableView
extension MyListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (MyPostManager.shared.myPosts ?? []).count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as! MyListTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.setCell(text: "新規投稿を作成", image: UIImage(systemName: "plus")!, imageViewContentMode: .center)
        default:
            let index = indexPath.row - 1
            let myPost = (MyPostManager.shared.myPosts ?? [])[index]
            cell.setCell(text: myPost.post?.title ?? "", image: myPost.image ?? UIImage(), imageViewContentMode: .scaleAspectFill)
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
