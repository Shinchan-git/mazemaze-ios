//
//  PostCRUD.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/31.
//

import UIKit
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
                "senderName": post.senderName ?? "",
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
    
    static func readPostsByField(where key: String, isEqualTo value: Any, limit: Int = 30) async throws -> [Post]? {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("posts").whereField(key, isEqualTo: value).order(by: "date", descending: true).limit(to: limit).getDocuments() { (querySnapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    if let documents = querySnapshot?.documents {
                        print("Successfully read posts by field")
                        let posts = documents.map { Post(document: $0) }
                        continuation.resume(returning: posts)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
    }
    
    static func readPostsByArray(where key: String, containsAnyOf array: [String], limit: Int) async throws -> [Post]? {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("posts").whereField(key, arrayContainsAny: array).limit(to: limit).getDocuments() { (querySnapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    if let documents = querySnapshot?.documents {
                        print("Successfully read posts by array")
                        let posts = documents.map { Post(document: $0) }
                        continuation.resume(returning: posts)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
    }
    
    static func reportPost(docId: String) {
        guard let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSf-27Lc0y3QjqT0njdbRd8LJMc85EWRvNlfwNKqmVz6M7oHNA/viewform?usp=pp_url&entry.1805428934=\(docId)") else { return }
        UIApplication.shared.open(url)
    }
    
}
