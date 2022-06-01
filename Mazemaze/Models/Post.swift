//
//  Post.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/30.
//

import Foundation
import Firebase

class Post {
    
    var id: String?
    var title: String?
    var imageUrl: String?
    var description: String?
    var relatedTags: [String] = []
    var senderId: String?
    var date: Date?
    var version: Int = 1
    
    init() {
        //Do nothing
    }
    
    init(document: DocumentSnapshot) {
        self.id = document["id"] as? String ?? ""
        self.title = document["title"] as? String ?? ""
        self.imageUrl = document["imageUrl"] as? String ?? ""
        self.description = document["description"] as? String ?? ""
        self.relatedTags = document["relatedTags"] as? [String] ?? []
        self.senderId = document["senderId"] as? String ?? ""
        self.date = document["date"] as? Date
        self.version = document["version"] as? Int ?? 1
    }
    
}
