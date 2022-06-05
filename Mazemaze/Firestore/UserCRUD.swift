//
//  UserCRUD.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/27.
//

import Foundation
import Firebase

class UserCRUD {
    
    static func createUser(user: User) async throws -> ResultType? {
        try await withCheckedThrowingContinuation { continuation in
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
                    continuation.resume(throwing: error)
                } else {
                    print("Successfully created user")
                    continuation.resume(returning: .success)
                }
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
    
    static func updateUser(userId: String, key: String, value: Any) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("users").document(userId).updateData([
                key: value
            ]) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    print("Successfully updated user")
                    continuation.resume(returning: userId)
                }
            }
        }
    }
    
    static func updateUserArray(userId: String, key: String, unite array: [Any]) async throws -> ResultType? {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("users").document(userId).updateData([
                key : FieldValue.arrayUnion(array)
            ]) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    print("Successfully united array in user")
                    continuation.resume(returning: .success)
                }
            }
        }
    }
    
}
