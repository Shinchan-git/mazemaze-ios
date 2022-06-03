//
//  RecommendedViewController.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/22.
//

import UIKit

class RecommendedViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    let userManager = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "RecommendedPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendedPostCollectionViewCell")
        setupNavBar()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = AuthManager.userId() {
            loginButton.isHidden = true
            
            if let _ = RecommendedPostManager.shared.posts {} else {
                Task {
                    //TODO
//                    await loadRelatedPosts(tags: [])
                }
            }
        } else {
            loginButton.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupCollectionView()
    }
    
    func loadRelatedPosts(tags: [String]) async {
        do {
            async let relatedPosts = PostCRUD.readPostsByArray(where: "selectedTags", containsAnyOf: tags)
            if let relatedPosts = try await relatedPosts {
                RecommendedPostManager.shared.posts = relatedPosts.map { DisplayedPost(post: $0, image: nil) }
                collectionView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
}

//CollectionView
extension RecommendedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecommendedPostManager.shared.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedPostCollectionViewCell", for: indexPath) as! RecommendedPostCollectionViewCell
        let recommendedPost = RecommendedPostManager.shared.posts?[indexPath.row]
        cell.setCell(image: recommendedPost?.image ?? UIImage(), title: recommendedPost?.post?.title ?? "", senderName: recommendedPost?.post?.senderName ?? "")
        return cell
    }
    
}

//UI
extension RecommendedViewController {
    
    func setupNavBar() {
        self.navigationItem.title = "おすすめ"
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = (self.view.frame.size.width - 48) / 2
        layout.itemSize = CGSize(width: width, height: width + 50)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
        collectionView.collectionViewLayout = layout
    }
    
    func setupViews() {
        loginButton.isHidden = true
    }
    
}
