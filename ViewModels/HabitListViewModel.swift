import SwiftUI
import Combine

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] {
        didSet {
            saveHabits()
        }
    }
    @Published var activeSheet: ActiveSheet?

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

    private func saveHabits() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(habits) {
            UserDefaults.standard.set(data, forKey: "habits")
        }
    }

    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }

    func editHabit(_ habit: Habit) {
        activeSheet = .editHabit(habit: habit)
    }

    func createNewHabit() {
        activeSheet = .addHabit
    }
    
    func resetStreaksIfNeeded() {
        let now = Date()
        let calendar = Calendar.current

        habits = habits.map { habit in
            var updatedHabit = habit

            if let lastCompletionDate = habit.completionDates.last {
                let lastCompletionDateIsYesterday = calendar.isDateInYesterday(lastCompletionDate)
                let lastCompletionDateIsToday = calendar.isDateInToday(lastCompletionDate)
                
                if habit.isCompleted && !lastCompletionDateIsToday {
                    updatedHabit.completionDates.append(now)
                    updatedHabit.streak += 1
                    updatedHabit.longestStreak = max(updatedHabit.streak, updatedHabit.longestStreak)
                    updatedHabit.isCompleted = false
                } else if !lastCompletionDateIsYesterday && !lastCompletionDateIsToday {
                    updatedHabit.streak = 0
                    updatedHabit.isCompleted = false
                }
            } else if habit.isCompleted {
                updatedHabit.completionDates.append(now)
                updatedHabit.streak = 1
                updatedHabit.longestStreak = max(updatedHabit.streak, updatedHabit.longestStreak)
                updatedHabit.isCompleted = false
            }

            return updatedHabit
        }

        saveHabits()
    }
}









