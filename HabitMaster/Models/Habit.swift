import Foundation
import SwiftUI

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var subtitle: String
    var isCompleted: Bool
    var creationDate: Date
    var completionDates: [Date]
    var longestStreak: Int
    var currentStreak: Int
    var completionDate: Date
    
    init(id: UUID = UUID(), name: String, subtitle: String, isCompleted: Bool = false, creationDate: Date = Date(), completionDates: [Date] = [], longestStreak: Int = 0, currentStreak: Int = 0, completionDate: Date = Date()) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.completionDates = completionDates
        self.longestStreak = longestStreak
        self.currentStreak = currentStreak
        self.completionDate = completionDate
    }
    
    init(name: String, subtitle: String) {
        self.init(id: UUID(), name: name, subtitle: subtitle, isCompleted: false, creationDate: Date(), completionDates: [], longestStreak: 0, completionDate: Date())
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
        longestStreak = try container.decode(Int.self, forKey: .longestStreak)
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
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
        try container.encode(longestStreak, forKey: .longestStreak)
        try container.encode(completionDate, forKey: .completionDate)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    mutating func updateStreaks() {
        currentStreak = 0
        if completionDates.count > 1 {
            for i in stride(from: completionDates.count - 1, through:         1, by: -1) {
                let date1 = completionDates[i]
                let date2 = completionDates[i-1]
                if Calendar.current.isDate(date1, inSameDayAs: date2.addingTimeInterval(24*60*60)) {
                    currentStreak += 1
                } else {
                    break
                }
            }
        }
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
    }
    
    mutating func toggleCompletion() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        if !isCompleted {
            isCompleted = true
            completionDates.append(currentDate)
            
            if let lastCompletionDate = completionDates.last, calendar.isDate(lastCompletionDate.addingTimeInterval(24*60*60), equalTo: currentDate, toGranularity: .day) {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
            
            if currentStreak > longestStreak {
                longestStreak = currentStreak
            }
        } else {
            isCompleted = false
            
            if let lastCompletionDate = completionDates.last, calendar.isDateInToday(lastCompletionDate) {
                completionDates.removeLast()
                
                if currentStreak > 0 {
                    currentStreak -= 1
                }
            }
        }
        
        completionDate = currentDate
    }
}

