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
            saveHabits()
        }
    }
    private var habitSubscriptions: [UUID: AnyCancellable] = [:]
    
    init() {
        loadHabits()
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveHabits()
        }
    }
    
    func loadHabits() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "habits"),
           let decodedHabits = try? decoder.decode([Habit].self, from: data) {
            self.habits = decodedHabits
            // Resubscribe to the objectWillChange publisher for each habit
            for habit in habits {
                habitSubscriptions[habit.id] = habit.objectWillChange.sink { [weak self] _ in
                    self?.objectWillChange.send()
                    self?.saveHabits()
                }
            }
        }
    }

    
    func saveHabits() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(habits) {
            UserDefaults.standard.set(encodedData, forKey: "habits")
        } else {
            print("Failed to encode habits")
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
            
            if habit.isCompleted != isCompleted {
                if isCompleted {
                    habit.currentStreak += 1
                    habit.isCompletedYesterday = true
                    
                    if habit.currentStreak > habit.longestStreak {
                        habit.longestStreak = habit.currentStreak
                    }
                } else if habit.currentStreak > 0 {
                    habit.currentStreak -= 1
                    
                    if habit.currentStreak < habit.longestStreak {
                        habit.longestStreak = habit.currentStreak
                    }
                }
            }

            habit.isCompleted = isCompleted
            saveHabits()
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
                
                if !habit.isCompletedYesterday && habit.longestStreak > 0 {
                    habit.longestStreak -= 1
                }
                
                habit.isCompletedYesterday = false
            }
            
            saveHabits()
        }
    }

    func getIndex(byId id: UUID) -> Int? {
        return habits.firstIndex(where: { $0.id == id })
    }
    
    func resetStreaksIfNeeded() {
        let calendar = Calendar.current
        for index in habits.indices {
            let habit = habits[index]
            let isSameDay = habit.completionDates.last.map { calendar.isDateInToday($0) } ?? false
            
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















