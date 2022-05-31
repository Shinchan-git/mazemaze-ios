//
//  SubmitButtonTableViewCell.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/31.
//

import UIKit

class SubmitButtonTableViewCell: UITableViewCell {
    
    @IBOutlet var submitButton: UIButton!
    
    var delegate: SubmitButtonCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onSubmitButton() {
        delegate?.onSubmitButton(cell: self)
    }
    
    func setCell(text: String, isButtonEnabled: Bool) {
        submitButton.setTitle(text, for: .normal)
        submitButton.isEnabled = isButtonEnabled
    }
    
    func setIsLoading(text: String) {
        submitButton.isEnabled = false
        submitButton.setTitle(text, for: .normal)
    }
    
    //UI
    func setupViews() {
        self.selectionStyle = .none
        submitButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
    }
    
}

protocol SubmitButtonCellDelegate: AnyObject {
    func onSubmitButton(cell: SubmitButtonTableViewCell)
}
