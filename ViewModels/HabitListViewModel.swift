import Foundation

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    var streakViewModel = StreakViewModel()
    
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
    func toggleHabitCompletion(at index: Int) {
        habits[index].isCompleted.toggle()
        streakViewModel.updateStreak(for: &habits[index]) // Use streakViewModel here
    }
    func updateStreaksIfNeeded() {
        for index in habits.indices {
            streakViewModel.updateStreak(for: &habits[index]) // Use streakViewModel here
        }
    }

}











