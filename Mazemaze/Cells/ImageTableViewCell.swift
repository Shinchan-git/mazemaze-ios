//
//  ImageTableViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/29.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet var bookImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(image: UIImage?) {
        if let image = image {
            bookImageView.contentMode = .scaleAspectFill
            bookImageView.image = image
        } else {
            bookImageView.contentMode = .center
            bookImageView.image = UIImage(systemName: "photo")
        }
    }
    
    //UI
    func setupViews() {
        self.selectionStyle = .none
        bookImageView.preferredSymbolConfiguration = .init(pointSize: 36)
        bookImageView.layer.cornerRadius = 3
    }
    
    
}
