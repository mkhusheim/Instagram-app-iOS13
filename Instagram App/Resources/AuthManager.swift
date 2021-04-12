//
//  AuthManager.swift
//  Instagram App
//
//  Created by Maram on 30/08/1442 AH.
// This file will manage everything related to our Authentication

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    // Mark: - Public
    // Public functions that anyone in the app could use

    // Register user
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        /*
         - Check if username is available
         - Check if email is available
         - Create account
         - Insert account to database
         */
        // - Check if username is available
        // - Check if email is available// - Insert account to database
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { (canCreate) in
            if canCreate {
                // - Create account
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                   guard error == nil, result != nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    // - Insert account to database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                            return
                        } else {
                            // Failed to inset to database
                            completion(false)
                            return
                        }
                    }
                }
            } else {
                // Either username or email already exist
                completion(false)
            }
        }
    }

    // Login user
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            // email log in
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else {
                    completion (false)
                    return
                }
                completion(true)
            }
            
        } else if let username = username {
            // username log in
            print (username)
            
        }
    }
    
}

