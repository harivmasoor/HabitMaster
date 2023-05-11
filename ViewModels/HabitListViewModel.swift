import Foundation
import Combine
import SwiftUI

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            // When a habit is added, subscribe to its changes
            if habits.count > oldValue.count {
                let newHabit = habits.last!
                habitSubscriptions[newHabit.id] = newHabit.objectWillChange.sink { [weak self] _ in
                    self?.objectWillChange.send()
                    self?.saveHabits()
                }
            }
            // When a habit is removed, unsubscribe from its changes
            else if habits.count < oldValue.count {
                for habit in oldValue where !habits.contains(habit) {
                    habitSubscriptions[habit.id]?.cancel()
                    habitSubscriptions[habit.id] = nil
                }
            }
        }
    }
    private var habitSubscriptions: [UUID: AnyCancellable] = [:]
    
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
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveHabits()
        }
    }
    
    func saveHabits() {
        let encoder = JSONEncoder()
        if let encodedHabits = try? encoder.encode(habits) {
            UserDefaults.standard.set(encodedHabits, forKey: "habits")
        }
    }

    func deleteHabit(id: UUID) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits.remove(at: index)
            saveHabits()
        }
    }

    func deleteHabit(atOffsets offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
        saveHabits()
    }
    
    func updateHabitCompletionState(id: UUID, isCompleted: Bool) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            let habit = habits[index]
            
            // Only update the streak if the state is actually changing
            if habit.isCompleted != isCompleted {
                if isCompleted {
                    habit.currentStreak += 1
                    habit.isCompletedYesterday = true  // Set isCompletedYesterday to true when the habit is completed
                } else if habit.currentStreak > 0 {
                    habit.currentStreak -= 1
                }
            }

            habit.isCompleted = isCompleted
            saveHabits()  // Save the updated habits array
        }
    }


    func resetHabitsIfNeeded() {
        let calendar = Calendar.current
        for index in habits.indices {
            let habit = habits[index]
            let isSameDay = calendar.isDateInToday(habit.completionDate)
            
            if !isSameDay {
                habit.isCompleted = false
                habit.currentStreak = 0
            }
        }
        saveHabits()
    }

    func getIndex(byId id: UUID) -> Int? {
        return habits.firstIndex(where: { $0.id == id })
    }
    func resetStreaksIfNeeded() {
        let calendar = Calendar.current
        for index in habits.indices {
            let habit = habits[index]
            let isSameDay = calendar.isDateInToday(habit.completionDate)
            
            // If it's not the same day and the habit was not completed yesterday, then reset the streak
            if !isSameDay && !habit.isCompletedYesterday {
                habit.currentStreak = 0
                habit.isCompletedYesterday = false
            }
            // If it is the same day and the habit was completed yesterday, then keep the streak and set isCompletedYesterday to false for the next check
            else if isSameDay && habit.isCompletedYesterday {
                habit.isCompletedYesterday = false
            }
        }
        saveHabits()
    }

    func timeRemainingUntilMidnight() -> TimeInterval {
        let calendar = Calendar.current
        let now = Date()
        let nextMidnight = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
        return nextMidnight.timeIntervalSince(now)
    }

}
















