//
//  User.swift
//  HabitMaster
//
//  Created by Hari Masoor on 5/4/23.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String
    let hashedPassword: String
    var preferences: UserPreferences
}

struct UserPreferences: Codable {
    var notificationsEnabled: Bool
    var dailyReminderTime: Date?
    // Add any other user preferences here
}

