///habit.swift
import Foundation

struct Habit: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var subtitle: String
    var isCompleted: Bool
    var creationDate: Date
    var completionDates: [Date]
    var streak: Int
    var longestStreak: Int

    init(id: UUID = UUID(), name: String, subtitle: String, isCompleted: Bool = false, creationDate: Date = Date(), completionDates: [Date] = [], streak: Int = 0, longestStreak: Int = 0) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.completionDates = completionDates
        self.streak = streak
        self.longestStreak = longestStreak
    }

    init(name: String, subtitle: String) {
        self.init(id: UUID(), name: name, subtitle: subtitle, isCompleted: false, creationDate: Date(), completionDates: [], streak: 0, longestStreak: 0)
    }

    var completionDateFormatted: String {
        guard let lastCompletionDate = completionDates.last else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: lastCompletionDate)
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, name, subtitle, isCompleted, creationDate, completionDates, streak, longestStreak
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        completionDates = try container.decode([Date].self, forKey: .completionDates)
        streak = try container.decode(Int.self, forKey: .streak)
        longestStreak = try container.decode(Int.self, forKey: .longestStreak)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(completionDates, forKey: .completionDates)
        try container.encode(streak, forKey: .streak)
        try container.encode(longestStreak, forKey: .longestStreak)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
