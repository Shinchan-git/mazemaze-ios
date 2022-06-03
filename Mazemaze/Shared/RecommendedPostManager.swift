//
//  RecommendedPostManager.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/03.
//

import Foundation

class RecommendedPostManager {
    
    static let shared = RecommendedPostManager()
    
    var posts: [DisplayedPost]?
    
    private init() {
        //Do nothing
    }
    
}
