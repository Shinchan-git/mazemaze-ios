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
                "title": post.title ?? "",
                "imgUrl": post.imgUrl ?? "",
                "description": post.description ?? "",
                "relatedTags": post.relatedTags,
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
    
    static func addCreatedPostId(userId: String, postId: String) async throws -> ResultType? {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("users").document(userId).updateData([
                "createdPostIds": FieldValue.arrayUnion([postId])
            ]) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    print("Successfully added created post id")
                    continuation.resume(returning: .success)
                }
            }
        }
    }
    
}
