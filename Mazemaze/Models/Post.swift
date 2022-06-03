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
    var selectedTags: [String] = []
    var enteredTags: [String] = []
    var senderId: String?
    var senderName: String?
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
        self.selectedTags = document["selectedTags"] as? [String] ?? []
        self.enteredTags = document["enteredTags"] as? [String] ?? []
        self.senderId = document["senderId"] as? String ?? ""
        self.senderName = document["senderName"] as? String ?? ""
        self.date = document["date"] as? Date
        self.version = document["version"] as? Int ?? 1
    }
    
}
