//
//  TextButtonTableViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/29.
//

import UIKit

class TextButtonTableViewCell: UITableViewCell {
    
    @IBOutlet var button: UIButton!

    var delegate: TextButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onTextButton() {
        delegate?.onTextButton(cell: self)
    }
    
    func setCell(text: String) {
        button.setTitle(text, for: .normal)
    }
    
    //UI
    func setupViews() {
        self.selectionStyle = .none
    }
    
}


protocol TextButtonCellDelegate: AnyObject {
    func onTextButton(cell: TextButtonTableViewCell)
}
