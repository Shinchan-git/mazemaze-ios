//
//  MyPostManager.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/01.
//

import Foundation

class MyPostManager {
    
    static let shared = MyPostManager()
    
    var myPosts: [DisplayedPost]?
    var myTags: [String]?
    
    private init() {
        //Do nothing
    }
    
}
