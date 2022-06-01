//
//  Post.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/30.
//

import Foundation

class Post {
    
    var id: String?
    var title: String?
    var imageUrl: String?
    var description: String?
    var relatedTags: [String] = []
    var senderId: String?
    var date: Date?
    var version: Int = 1
    
}
