//
//  SupportingTextTableViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/29.
//

import UIKit

class SupportingTextTableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(text: String) {
        label.text = text
    }
    
    //UI
    func setupViews() {
        self.selectionStyle = .none
    }
    
}
