//
//  ImageCRUD.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/01.
//

import Foundation
import FirebaseStorage
import UIKit

class ImageCRUD {
    
    static func uploadImage(userId: String, docId: String, image: UIImage) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            let storage = Storage.storage()
            let folderPath = "gs://mazemaze-1e406.appspot.com/"
            let reference = storage.reference(forURL: folderPath)
            let imageRef = reference.child(userId).child("\(docId).jpeg")
            
            if let imageData = image.jpegData(compressionQuality: 0.1)  {
                imageRef.putData(imageData, metadata: nil) { (metaData, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        print("Successfully uploaded image")
                        let imageUrl = "\(folderPath)\(userId)/\(docId).jpeg"
                        continuation.resume(returning: imageUrl)
                    }
                }
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
    
}

