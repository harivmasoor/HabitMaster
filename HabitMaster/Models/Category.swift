//
//  Category.swift
//  HabitMaster
//
//  Created by Hari Masoor on 5/4/23.
//

import SwiftUI

struct Category: Identifiable, Codable {
    let id: UUID
    let name: String
    let color: CodableColor
    var habits: [Habit]
}

