//
//  PostCRUD.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/31.
//

import Foundation
import Firebase

class PostCRUD {
    
    static func createPost(post: Post) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            let doc = db.collection("posts").document()
            doc.setData([
                "id": doc.documentID,
                "title": post.title ?? "",
                "imageUrl": post.imageUrl ?? "",
                "description": post.description ?? "",
                "selectedTags": post.selectedTags,
                "enteredTags": post.enteredTags,
                "senderId": post.senderId ?? "",
                "date": post.date ?? Date(),
                "version": post.version
            ]) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    print("Successfully created post")
                    continuation.resume(returning: doc.documentID)
                }
            }
        }
    }
    
    static func updatePost(docId: String, key: String, value: Any) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("posts").document(docId).updateData([
                key: value
            ]) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    print("Successfully updated post")
                    continuation.resume(returning: docId)
                }
            }
        }
    }
    
    static func readPostByField(where key: String, isEqualTo value: Any) async throws -> [Post]? {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("posts").whereField(key, isEqualTo: value).getDocuments() { (querySnapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    if let documents = querySnapshot?.documents {
                        print("Successfully read posts")
                        let posts = documents.map { Post(document: $0) }
                        continuation.resume(returning: posts)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
    }
    
}
