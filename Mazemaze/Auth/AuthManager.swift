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
    
    static func isLoggedIn() -> Bool {
        if let uid = Auth.auth().currentUser?.uid {
            print("uid: \(uid)")
            return true
        } else {
            print("Not logged in")
            return false
        }
    }
    
    static func signInWithGoogle(viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [unowned viewController] user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Successfully logged in")
                    viewController.dismiss(animated: true)
                }
            }
        }
    }
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print (error.localizedDescription)
        }
    }
    
}
