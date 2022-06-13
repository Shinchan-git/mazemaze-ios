//
//  SignInWithAppleIdButton.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/13.
//

import UIKit
import AuthenticationServices

@IBDesignable
class SignInWithAppleIDButton: UIButton {
    
    private var appleIDButton: ASAuthorizationAppleIDButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        appleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .whiteOutline)
        appleIDButton.addTarget(self, action: #selector(appleIDButtonTapped), for: .touchUpInside)
        
        addSubview(appleIDButton)
        
        appleIDButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleIDButton.topAnchor.constraint(equalTo: self.topAnchor),
            appleIDButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            appleIDButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            appleIDButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    @objc func appleIDButtonTapped(_ sender: Any) {
        sendActions(for: .touchUpInside)
    }
    
}
