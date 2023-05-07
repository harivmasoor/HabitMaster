///habit.swift
import Foundation

struct Habit: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var subtitle: String
    var isCompleted: Bool
    var creationDate: Date
    var completionDate: Date
    var completionDates: [Date]
    var streak: Int
    var currentStreak: Int
    var longestStreak: Int
    var completionPercentage: Double
    var lastCompleted: Date?
    
    

    init(id: UUID = UUID(), name: String, subtitle: String, isCompleted: Bool = false, creationDate: Date = Date(), completionDates: [Date] = [], streak: Int = 0, longestStreak: Int = 0, currentStreak: Int = 0, completionPercentage: Double = 0, lastCompleted: Date? = nil, completionDate: Date = Date()) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.completionDates = completionDates
        self.streak = streak
        self.longestStreak = longestStreak
        self.currentStreak = currentStreak
        self.completionPercentage = completionPercentage
        self.lastCompleted = lastCompleted
        self.completionDate = completionDate
    }

    init(name: String, subtitle: String) {
        self.init(id: UUID(), name: name, subtitle: subtitle, isCompleted: false, creationDate: Date(), completionDates: [], streak: 0, longestStreak: 0, lastCompleted: nil, completionDate: Date())
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
        case id, name, subtitle, isCompleted, creationDate, completionDates, streak, longestStreak, currentStreak, completionPercentage, lastCompleted, completionDate
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
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
        completionPercentage = try container.decode(Double.self, forKey: .completionPercentage)
        lastCompleted = try container.decode(Date.self, forKey: .lastCompleted)
        completionDate = try container.decode(Date.self, forKey: .completionDate)
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
        try container.encode(completionPercentage, forKey: .completionPercentage)
        try container.encode(lastCompleted, forKey: .lastCompleted)
        try container.encode(completionDate, forKey: .completionDate)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
