//
//  DisplayedPost.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/02.
//

import UIKit

class DisplayedPost {
    
    var post: Post?
    var image: UIImage?
    
    init(post: Post, image: UIImage?) {
        self.post = post
        self.image = image
    }
    
}
