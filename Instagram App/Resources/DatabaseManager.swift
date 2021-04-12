//
//  DatabaseManager.swift
//  Instagram App
//
//  Created by Maram on 30/08/1442 AH.
// This file will manage everything related to our database

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    // Mark: - Public
    // Public functions that anyone in the app could use
    /// Check if username and email is available
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    // Mark: - Public
    // Public functions that anyone in the app could use
    /// Insert new user data to database
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    ///     - completion: Async callback for result if database entry succeded
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username":username]) { error, _ in
            if error == nil {
                // Success
                completion(true)
                print ("Success")
            }else {
                // Failed
                completion(false)
            }
        }
    }
}
