//
//  SetUnderlineInTextField.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/31.
//

import UIKit

extension UITextField {
    
    func setUnderLine() {
        borderStyle = .none
        let border = CALayer()
        let borderWeight = CGFloat(0.6)
        border.borderColor = UIColor.secondaryLabel.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWeight, width:  10000, height: self.frame.size.height)
        border.borderWidth = borderWeight
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
