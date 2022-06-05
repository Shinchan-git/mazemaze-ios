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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "RecommendedPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendedPostCollectionViewCell")
        setupNavBar()
        setupViews()
        
        if let userId = AuthManager.userId() {
            loginButton.isHidden = true
            collectionView.isHidden = false
            
            if let _ = RecommendedPostManager.shared.posts {} else {
                Task {
                    if let myTags = MyPostManager.shared.myTags {
                        //Load related posts, Load other posts
                        await loadRelatedPosts(tags: myTags, limit: Constants.minimumRecommendationCount / 2)
                        await loadOtherPosts(tags: unrelatedTags())
                    } else {
                        if let myPosts = MyPostManager.shared.myPosts {
                            //Get my tags, Load related posts, Load other posts
                            await loadRelatedPosts(tags: myTags(myPosts: myPosts), limit: Constants.minimumRecommendationCount / 2)
                            await loadOtherPosts(tags: unrelatedTags())
                        } else {
                            //Load my posts, Get my tags, Load related posts, Load other posts
                            await loadMyPosts(userId: userId)
                        }
                    }
                }
            }
        } else {
            loginButton.isHidden = false
            collectionView.isHidden = true
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
                await loadRelatedPosts(tags: myTags(myPosts: myPosts), limit: Constants.minimumRecommendationCount / 2)
                await loadOtherPosts(tags: unrelatedTags())
            }
        } catch {
            print(error)
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
    
    func loadRelatedPosts(tags: [String], limit: Int) async {
        if tags == [] { return }
        do {
            async let relatedPosts = PostCRUD.readPostsByArray(where: "selectedTags", containsAnyOf: tags, limit: limit)
            if let relatedPosts = try await relatedPosts {
                let safePosts = await filterPosts(relatedPosts: relatedPosts)
                if let _ = RecommendedPostManager.shared.posts {} else {
                    RecommendedPostManager.shared.posts = []
                }
                RecommendedPostManager.shared.posts?.append(contentsOf: safePosts)
                collectionView.reloadData()
                await loadRelatedPostImages(posts: safePosts)
            }
        } catch {
            print(error)
        }
    }
    
    func filterPosts(relatedPosts: [Post]) async -> [DisplayedPost] {
        let posts = withoutAlreadyDisplayedPosts(relatedPosts: relatedPosts)
        var safePosts: [DisplayedPost] = []
        if let blockUserIds = UserManager.shared.blockUserIds {
            safePosts = withoutBlockUserPosts(posts: posts, blockUserIds: blockUserIds)
        } else {
            do {
                async let user = UserCRUD.getUser(uid: UserManager.shared.id ?? "")
                if let user = try await user {
                    UserManager.shared.setBlockUserIds(blockUserIds: user.blockUserIds)
                    safePosts = withoutBlockUserPosts(posts: posts, blockUserIds: user.blockUserIds)
                }
            } catch {
                print(error)
            }
        }
        return safePosts
    }
    
    func withoutAlreadyDisplayedPosts(relatedPosts: [Post]) -> [DisplayedPost] {
        let posts = relatedPosts.map { DisplayedPost(post: $0, image: nil) }
        let alreadyDisplayedPostSenderIds: [String] = (RecommendedPostManager.shared.posts ?? []).map { $0.post?.senderId ?? "" }
        let filtered = posts.filter { !alreadyDisplayedPostSenderIds.contains($0.post?.senderId ?? "") }
        return filtered
    }
    
    func withoutBlockUserPosts(posts: [DisplayedPost], blockUserIds: [String]) -> [DisplayedPost] {
        let filtered = posts.filter { !blockUserIds.contains($0.post?.senderId ?? "") }
        return filtered
    }
    
    func loadRelatedPostImages(posts: [DisplayedPost]) async {
        for (index, post) in posts.enumerated() {
            do {
                let image = try await ImageCRUD.readImage(userId: post.post?.senderId ?? "", docId: post.post?.id ?? "")
                RecommendedPostManager.shared.posts?[index].image = image
                collectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func unrelatedTags() -> [String] {
        let myTags = MyPostManager.shared.myTags ?? []
        var filteredTags: [String] = []
        for tags in Constants.relatedTags {
            let randomTags = tags.filter{!myTags.contains($0)}.shuffled().prefix(Int(10/Constants.relatedTags.count))
            filteredTags.append(contentsOf: randomTags)
        }
        return filteredTags
    }
    
    func loadOtherPosts(tags: [String]) async {
        let postsToBeLoadedCount = Constants.minimumRecommendationCount - (RecommendedPostManager.shared.posts?.count ?? 0)
        if postsToBeLoadedCount > 0 {
            await loadRelatedPosts(tags: tags, limit: postsToBeLoadedCount)
        }
    }
    
    func onBlockUser(blockUserId: String) {
        let alert = UIAlertController(
            title: "このユーザーをブロック",
            message: "このユーザーの投稿はあなたのおすすめに表示されなくなります。",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "ブロック",
            style: .destructive,
            handler: { _ in
                let userId = UserManager.shared.id ?? AuthManager.userId() ?? ""
                Task {
                    await self.blockUser(userId: userId, blockUserId: blockUserId)
                    RecommendedPostManager.shared.posts?.removeAll(where: { $0.post?.senderId == blockUserId })
                    self.collectionView.reloadData()
                }
            }
        ))
        alert.addAction(UIAlertAction(
            title: "キャンセル",
            style: .cancel,
            handler: nil
        ))
        present(alert, animated: true, completion: nil)
    }
    
    func blockUser(userId: String, blockUserId: String) async {
        do {
            async let result = UserCRUD.updateUserArray(userId: userId, key: "blockUserIds", unite: [blockUserId])
            if let _ = try await result {
                UserManager.shared.addBlockUserId(blockUserId: blockUserId)
            }
        } catch {
            print(error)
        }
    }

    func reportPost(docId: String) {
        //TODO
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
        let menuItems = { (docId: String, senderId: String) -> [UIAction] in
            [
                UIAction(title: "このユーザーをブロック", image: UIImage(systemName: "nosign"), handler: { _ in
                    self.onBlockUser(blockUserId: senderId)
                }),
                UIAction(title: "投稿を報告する", image: UIImage(systemName: "flag"), handler: { _ in
                    self.reportPost(docId: docId)
                })
            ]
        }
        cell.setCell(image: recommendedPost?.image ?? UIImage(), title: recommendedPost?.post?.title ?? "", senderName: recommendedPost?.post?.senderName ?? "", menuItems: menuItems, docId: recommendedPost?.post?.id ?? "", senderId: recommendedPost?.post?.senderId ?? "")
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
        collectionView.isHidden = true
    }
    
}
