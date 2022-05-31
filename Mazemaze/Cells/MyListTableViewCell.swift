//
//  MyListTableViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/29.
//

import UIKit

class MyListTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bookImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(text: String, image: UIImage) {
        titleLabel.text = text
        bookImageView.image = image
    }
    
    //UI
    func setupViews() {
        bookImageView.preferredSymbolConfiguration = .init(pointSize: 24)
        bookImageView.layer.cornerRadius = 3
    }
    
}
