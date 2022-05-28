//
//  UserCRUD.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/27.
//

import Foundation
import Firebase

class UserCRUD {
    
    static func createUser(user: User) {
        let db = Firestore.firestore()
        db.collection("users").document(user.id).setData([
            "id": user.id,
            "name": user.name,
            "iconName": user.iconName,
            "iconColor": user.iconColor,
            "createdPostIds": user.createdPostIds,
            "blockUserIds": user.blockUserIds,
            "version": user.version
        ]) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    static func getUser(uid: String) async throws -> User? {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("users").document(uid).getDocument { (document, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    if let document = document, document.exists {
                        let user = User(document: document)
                        continuation.resume(returning: user)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
    }
    
}
