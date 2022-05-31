//
//  SpacerTableViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/31.
//

import UIKit

class SpacerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(height: CGFloat) {
        self.frame.size.height = height
    }
    
}
