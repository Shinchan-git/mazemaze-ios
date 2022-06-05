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
    
    var getUser: User? {
        get {
            return self.user
        }
    }
    
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
    
    var blockUserIds: [String]? = nil
    
    private init() {
        //Do nothing
    }
    
    func setUser(id: String? = "", name: String? = "", blockUserIds: [String]? = []) {
        self.user.id = id ?? ""
        self.user.name = name ?? ""
        self.user.blockUserIds = blockUserIds ?? []
    }
    
    func setUserId(id: String? = "") {
        self.user.id = id ?? ""
    }
    
    func setUserName(name: String? = "") {
        self.user.name = name ?? ""
    }
    
    func setBlockUserIds(blockUserIds: [String]) {
        self.blockUserIds = blockUserIds
    }
    
    func addBlockUserId(blockUserId: String) {
        if let _ = self.blockUserIds {} else {
            self.blockUserIds = []
        }
        self.blockUserIds!.append(blockUserId)
        
    }
    
}
