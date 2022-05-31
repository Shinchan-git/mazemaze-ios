//
//  TextFieldTableViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/31.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet var textField: UITextField!
    
    var delegate: TextFieldCellDelegate?
    var cellType: CellType?
    var relatedTagIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(text: String, placeholder: String, cellType: CellType, relatedTagIndex: Int?) {
        textField.text = text
        textField.placeholder = placeholder
        self.cellType = cellType
        self.relatedTagIndex = relatedTagIndex
    }
    
    //UI
    func setupViews() {
        textField.setUnderLine()
        textField.returnKeyType = .done
        self.selectionStyle = .none
    }
    
}

extension TextFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(cell: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(text: textField.text, cell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

protocol TextFieldCellDelegate: AnyObject {
    func textFieldDidBeginEditing(cell: TextFieldTableViewCell)
    func textFieldDidEndEditing(text: String?, cell: TextFieldTableViewCell)
}
