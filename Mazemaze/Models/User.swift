//
//  User.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/27.
//

import Foundation
import Firebase

class User {
    
    var id: String
    var name: String
    var iconName: String = "person.fill"
    var iconColor: String = "262626"
    var createdPostIds: [String] = []
    var blockUserIds: [String] = []
    var version: Int = 1
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(document: DocumentSnapshot) {
        self.id = document["id"] as? String ?? ""
        self.name = document["name"] as? String ?? ""
        self.iconName = document["iconName"] as? String ?? ""
        self.iconColor = document["iconColor"] as? String ?? ""
        self.createdPostIds = document["createdPostIds"] as? [String] ?? []
        self.blockUserIds = document["blockUserIds"] as? [String] ?? []
        self.version = document["version"] as? Int ?? 1
    }
    
}
