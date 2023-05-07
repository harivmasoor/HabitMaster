//
//  Achievement.swift
//  HabitMaster
//
//  Created by Hari Masoor on 5/4/23.
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let iconName: String
    var isUnlocked: Bool
}
