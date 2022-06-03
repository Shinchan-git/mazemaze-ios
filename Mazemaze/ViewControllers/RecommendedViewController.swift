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
        if let userId = AuthManager.userId() {
            loginButton.isHidden = true
            
            if let _ = RecommendedPostManager.shared.posts {} else {
                Task {
                    if let myTags = MyPostManager.shared.myTags {
                        //Load related posts
                        await loadRelatedPosts(tags: myTags)
                    } else {
                        if let myPosts = MyPostManager.shared.myPosts {
                            //Get my tags, Load related posts
                            await loadRelatedPosts(tags: myTags(myPosts: myPosts))
                        } else {
                            //Load my posts, Get my tags, Load related posts
                            await loadMyPosts(userId: userId)
                        }
                    }
                }
            }
        } else {
            loginButton.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupCollectionView()
    }
    
    func loadMyPosts(userId: String) async {
        do {
            async let posts = PostCRUD.readPostsByField(where: "senderId", isEqualTo: userId)
            if let posts = try await posts {
                let myPosts = posts.map { DisplayedPost(post: $0, image: nil) }
                MyPostManager.shared.myPosts = myPosts
                await loadRelatedPosts(tags: myTags(myPosts: myPosts))
            }
        } catch {
            print("RecommendedViewController - Error loading my posts: \(error)")
        }
    }
    
    func myTags(myPosts: [DisplayedPost]) -> [String] {
        var allTags: [String] = []
        for myPost in myPosts {
            if let post = myPost.post {
                allTags.append(contentsOf: post.selectedTags)
            }
        }
        var myTags: [String] = []
        for _ in 0..<3 {
            if let mode = Stats.mode(ofString: allTags) {
                myTags.append(mode[0])
                allTags.removeAll(where: { $0 == mode[0] })
            } else {
                break
            }
        }
        MyPostManager.shared.myTags = myTags
        return myTags
    }
    
    func loadRelatedPosts(tags: [String]) async {
        if tags == [] { return }
        do {
            async let relatedPosts = PostCRUD.readPostsByArray(where: "selectedTags", containsAnyOf: tags)
            if let relatedPosts = try await relatedPosts {
                RecommendedPostManager.shared.posts = relatedPosts.map { DisplayedPost(post: $0, image: nil) }
                collectionView.reloadData()
                await loadRelatedPostImages(posts: relatedPosts)
            }
        } catch {
            print("RecommendedViewController - Error loading related posts: \(error)")
        }
    }
    
    func loadRelatedPostImages(posts: [Post]) async {
        for (index, post) in posts.enumerated() {
            do {
                let image = try await ImageCRUD.readImage(userId: post.senderId ?? "", docId: post.id ?? "")
                RecommendedPostManager.shared.posts?[index].image = image
                collectionView.reloadData()
            } catch {
                print("RecommendedViewController - Error loading related post images: \(error)")
            }
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
