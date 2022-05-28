//
//  UserManager.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/29.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    private var user = User(id: "", name: "")
    
    var id: String? {
        get {
            return self.user.id == "" ? nil : self.user.id
        }
    }
    
    var name: String? {
        get {
            return self.user.name == "" ? nil : self.user.name
        }
    }
    
    private init() {
        //Do nothing
    }
    
    func setUser(id: String = "", name: String = "") {
        self.user.id = id
        self.user.name = name
    }
}
