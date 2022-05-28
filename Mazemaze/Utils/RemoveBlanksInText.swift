//
//  RemoveBlanksInText.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/29.
//

import Foundation

extension String {
    
    func removeBlanks() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
}
