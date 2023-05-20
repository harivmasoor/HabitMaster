import Foundation
import SwiftUI
import Combine

final class Habit: ObservableObject, Identifiable, Codable, Equatable {
    let id: UUID
    @Published var name: String
    @Published var subtitle: String
    @Published var isCompleted: Bool
    @Published var creationDate: Date
    @Published var completionDates: [Date]
    @Published var longestStreak: Int
    @Published var currentStreak: Int
    @Published var completionDate: Date
    @Published var isCompletionDateManuallySet: Bool
    @Published var lastCompletionDate: Date?
    @Published var completedToday: Bool = false
    @Published var wasToggledOff: Bool = false
    
    
    init(id: UUID = UUID(), name: String, subtitle: String, isCompleted: Bool = false, creationDate: Date = Date(), completionDates: [Date] = [], longestStreak: Int = 0, currentStreak: Int = 0, completionDate: Date = Date(),isCompletionDateManuallySet: Bool = true, lastCompletionDate: Date?,completedToday: Bool = false, wasToggledOff: Bool = false ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.completionDates = completionDates
        self.longestStreak = longestStreak
        self.currentStreak = currentStreak
        self.completionDate = completionDate
        self.isCompletionDateManuallySet = isCompletionDateManuallySet
        self.lastCompletionDate = lastCompletionDate
        self.completedToday = completedToday
        self.wasToggledOff = wasToggledOff

    }
    
    convenience init(name: String, subtitle: String) {
        self.init(id: UUID(), name: name, subtitle: subtitle, isCompleted: false, creationDate: Date(), completionDates: [], longestStreak: 0, currentStreak: 0, completionDate: Date(), isCompletionDateManuallySet: true, lastCompletionDate: Date(), completedToday: false, wasToggledOff: false)
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
        case id, name, subtitle, isCompleted, creationDate, completionDates, longestStreak, currentStreak, completionDate, isCompletionDateManuallySet, lastCompletionDate, completedToday, wasToggledOff
    
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
        isCompletionDateManuallySet = try container.decode(Bool.self, forKey: .isCompletionDateManuallySet)
        lastCompletionDate = try container.decode(Date.self, forKey: .lastCompletionDate)
        completedToday = try container.decode(Bool.self, forKey: .completedToday)
        wasToggledOff = try container.decode(Bool.self, forKey: .wasToggledOff)
    
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
        try container.encode(currentStreak, forKey: .currentStreak)
        try container.encode(completionDate, forKey: .completionDate)
        try container.encode(isCompletionDateManuallySet, forKey: .isCompletionDateManuallySet)
        try container.encode(lastCompletionDate, forKey: .lastCompletionDate)
        try container.encode(completedToday, forKey: .completedToday)
        try container.encode(wasToggledOff, forKey: .wasToggledOff)
    
    }
    
    static func ==(lhs: Habit, rhs: Habit) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func toggleCompletion() {
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
                
                // Update longest streak if the habit was toggled off on the same day
                if currentStreak < longestStreak {
                    longestStreak = currentStreak
                }
            }
            // Update streaks based on completion dates
            updateStreaks()
        }
    }

    
    func updateStreaks() {
        currentStreak = 0
        if completionDates.count > 1 {
            for i in stride(from: completionDates.count - 1, through: 1, by: -1) {
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
}


