//
//  SelectionTableViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/03.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var label: UILabel!

    var delegate: SelectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            delegate?.cellSelected(labelText: label.text ?? "", cell: self)
        }
    }
    
    func setCell(text: String, isSelected: Bool) {
        label.text = text
        if isSelected {
            iconImageView.image = UIImage(systemName: "circle.inset.filled")
        } else {
            iconImageView.image = UIImage(systemName: "circle")
        }
    }

    //UI
    func setupViews() {
        self.selectionStyle = .none
        iconImageView.preferredSymbolConfiguration = .init(pointSize: 24)
    }
    
}

protocol SelectionCellDelegate: AnyObject {
    func cellSelected(labelText: String, cell: SelectionTableViewCell)
}
