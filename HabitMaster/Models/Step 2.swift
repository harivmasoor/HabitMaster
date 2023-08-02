import Foundation

final class StepCount: ObservableObject, Identifiable, Codable {
    var id = UUID()
    var goalSteps: Int
    @Published var actualSteps: Int
    var date: Date
    @Published var isCompleted: Bool
    @Published var lastCompletionDate: Date?
    @Published var currentStreak: Int
    @Published var longestStreak: Int // new property for longest streak
    @Published var completedYesterday: Bool
    
    @Published var healthKitManager = HealthKitManager()
    var isStreakCompleted: Bool { actualSteps >= goalSteps }

    init(goalSteps: Int, actualSteps: Int, date: Date, isCompleted: Bool = false, lastCompletionDate: Date? = nil, currentStreak: Int = 0, longestStreak: Int = 0) {
        self.goalSteps = goalSteps
        self.actualSteps = actualSteps
        self.date = date
        self.isCompleted = isCompleted
        self.lastCompletionDate = lastCompletionDate
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak // initializing the longest streak
        self.completedYesterday = isCompleted
    }

    enum CodingKeys: CodingKey {
        case id, goalSteps, actualSteps, date, isCompleted, lastCompletionDate, currentStreak, longestStreak, completedYesterday
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        goalSteps = try container.decode(Int.self, forKey: .goalSteps)
        actualSteps = try container.decode(Int.self, forKey: .actualSteps)
        date = try container.decode(Date.self, forKey: .date)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        lastCompletionDate = try container.decodeIfPresent(Date.self, forKey: .lastCompletionDate)
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
        longestStreak = try container.decode(Int.self, forKey: .longestStreak) // decoding the longest streak
        completedYesterday = try container.decode(Bool.self, forKey: .completedYesterday)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(goalSteps, forKey: .goalSteps)
        try container.encode(actualSteps, forKey: .actualSteps)
        try container.encode(date, forKey: .date)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(lastCompletionDate, forKey: .lastCompletionDate)
        try container.encode(currentStreak, forKey: .currentStreak)
        try container.encode(longestStreak, forKey: .longestStreak) // encoding the longest streak
        try container.encode(completedYesterday, forKey: .completedYesterday) // encoding

    }

    func increaseStreak() {
        let calendar = Calendar.current
        let isPreviousDay = lastCompletionDate.map { calendar.isDateInYesterday($0) } ?? false

        if isPreviousDay && currentStreak > 0 {
            currentStreak += 1
        }
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
        lastCompletionDate = Date()
    }

    func resetStreak() {
        currentStreak = 0
    }

    func updateSteps(steps: Int) {
        print("Updating steps: \(steps)") // Debug print statement
        self.actualSteps = steps
    }

}
