//
//  RecommendedPostCollectionViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/03.
//

import UIKit

class RecommendedPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var senderNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    func setCell(image: UIImage, title: String, senderName: String) {
        bookImageView.image = image
        titleLabel.text = title
        senderNameLabel.text = senderName
    }
    
    //UI
    func setupViews() {
        bookImageView.layer.cornerRadius = 3
    }
    
}
