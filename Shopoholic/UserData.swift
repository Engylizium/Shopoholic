//
//  UserData.swift
//  Shopoholic
//
//  Created by Соболев Пересвет on 5/24/23.
//
import Foundation

struct User: Codable {
    var name: String
    var email: String
    var phone: String
    var address: String
    var age: Int
}

class UserData {
    private let fileName = "UserData.json"
    
    func saveUser(_ user: User) {
        do {
            let jsonData = try JSONEncoder().encode(user)
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                try jsonData.write(to: fileURL)
                print("User data saved successfully.")
            }
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
    func loadUser() -> User? {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            do {
                let jsonData = try Data(contentsOf: fileURL)
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                return user
            } catch {
                print("Error loading user data: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
