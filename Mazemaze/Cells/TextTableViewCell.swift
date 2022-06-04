//
//  TextTableViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/05.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(text: String, color: UIColor = .label) {
        label.text = text
        label.textColor = color
    }
    
}
