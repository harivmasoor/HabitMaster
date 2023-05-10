import Foundation

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "habits") {
            let decoder = JSONDecoder()
            if let decodedHabits = try? decoder.decode([Habit].self, from: data) {
                self.habits = decodedHabits
            } else {
                self.habits = []
            }
        } else {
            self.habits = []
        }
    }
    
    func saveHabits() {
        let encoder = JSONEncoder()
        if let encodedHabits = try? encoder.encode(habits) {
            UserDefaults.standard.set(encodedHabits, forKey: "habits")
        }
    }
    
    func deleteHabit(at indexSet: IndexSet) {
        habits.remove(atOffsets: indexSet)
        saveHabits()
    }
    
    func timeRemainingUntilMidnight() -> TimeInterval {
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: Date().addingTimeInterval(24*60*60))
        let timeUntilMidnight = midnight.timeIntervalSinceNow
        return timeUntilMidnight
    }
    
    func updateHabitCompletionState(id: UUID, isCompleted: Bool) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].isCompleted = isCompleted
            // If the habit was just completed, add the current date to completionDates
            if isCompleted {
                habits[index].completionDates.append(Date())
                // Update streaks
                habits[index].updateStreaks()
            }
            // Save changes to UserDefaults
            saveHabits()
        }
    }
    func resetStreaksIfNeeded() {
        for index in habits.indices {
            if !Calendar.current.isDateInToday(habits[index].completionDate) && habits[index].isCompleted {
                habits[index].isCompleted = false
                habits[index].currentStreak = 0
            } else if Calendar.current.isDateInToday(habits[index].completionDate) && !habits[index].isCompleted {
                habits[index].isCompleted = true
                habits[index].currentStreak += 1
                if habits[index].currentStreak > habits[index].longestStreak {
                    habits[index].longestStreak = habits[index].currentStreak
                }
            }
        }
    }
    func getIndex(byId id: UUID) -> Int? {
        return habits.firstIndex(where: { $0.id == id })
    }

    
}














