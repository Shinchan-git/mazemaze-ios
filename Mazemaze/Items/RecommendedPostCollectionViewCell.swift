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
    @IBOutlet var menuButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    func setCell(image: UIImage, title: String, senderName: String, menuItems: ((_ docId: String, _ senderId: String) -> [UIAction]), docId: String, senderId: String) {
        bookImageView.image = image
        titleLabel.text = title
        senderNameLabel.text = senderName
        let menu = UIMenu(title: "", options: .displayInline, children: menuItems(docId, senderId))
        menuButton.menu = menu
        menuButton.setTitle("", for: .normal)
    }
    
    //UI
    func setupViews() {
        bookImageView.layer.cornerRadius = 3
        menuButton.layer.cornerRadius = 26 / 2
        menuButton.showsMenuAsPrimaryAction = true
    }
    
}
