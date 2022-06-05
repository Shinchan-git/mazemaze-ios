//
//  AuthManager.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/22.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthManager {
    
    static func userId() -> String? {
        let userId = Auth.auth().currentUser?.uid
        UserManager.shared.setUserId(id: userId)
        return userId
    }
    
    static func signInWithGoogle(viewController: UIViewController, completion: @escaping (String) -> Void) {
        if userId() != nil { return }
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    //Login succeeded
                    guard let uid = authResult?.user.uid else { return }
                    completion(uid)
                }
            }
        }
    }
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
