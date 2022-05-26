//
//  User.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/27.
//

import Foundation

class User {
    
    var id: String
    var iconName: String = "person.fill"
    var iconColor: String = "262626"
    var createdPostIds: [String] = []
    var blockUserIds: [String] = []
    var version: Int = 1
    
    init(id: String) {
        self.id = id
    }
    
    init(id: String, iconName: String, iconColor: String, createdPotIds: [String], blockUserIds: [String], version: Int) {
        self.id = id
        self.iconName = iconName
        self.iconColor = iconColor
        self.createdPostIds = createdPotIds
        self.blockUserIds = blockUserIds
        self.version = version
    }
    
}
